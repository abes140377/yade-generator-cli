from ansible.plugins.action import ActionBase
import gitlab

class ActionModule(ActionBase):
    def run(self, tmp=None, task_vars=None):
        # Merging task arguments with default variables
        super(ActionModule, self).run(tmp, task_vars)

        # Get parameters passed to the action plugin
        gitlab_url = self._task.args.get('gitlab_url', None)
        private_token = self._task.args.get('private_token', None)
        ssl_verify = self._task.args.get('ssl_verify', False)
        
        seed_config = self._task.args.get('seed_config', {})

        if not gitlab_url or not private_token:
            return {
                'failed': True,
                'msg': 'gitlab_url and private_token are required parameters'
            }

        try:
            # Initialize GitLab connection
            gl = gitlab.Gitlab(gitlab_url, private_token=private_token, ssl_verify=ssl_verify)
            
            # Test connection
            gl.auth()
            
            # You can now interact with GitLab API
            
            print(f"seed_config: {seed_config}")
            
            groups = seed_config.get('groups', [])
            
            # iterate over groups and create them
            for group in groups:
                group_name = group['name']
                group_path = group['path']
                group_description = group.get('description', f"Group for {group_name}")
                group_visibility = group.get('visibility', "private")

                print(f"Creating group: {group}")
                print(f"Group name: {group_name}")
                print(f"Group path: {group_path}")
                print(f"Group description: {group_description}")
                print(f"Group visibility: {group_visibility}")

                # create or update group
                try:
                    savedOrUpdatedGroup = gl.groups.create({
                        'name': group_name, 
                        'path': group_path, 
                        'description': group_description, 
                        'visibility': group_visibility,
                    })
                except gitlab.exceptions.GitlabCreateError as e:
                    savedOrUpdatedGroup = gl.groups.list(search=group_name)[0]
                    
                    savedOrUpdatedGroup.name = group_path
                    savedOrUpdatedGroup.path = group_path
                    savedOrUpdatedGroup.description = group_description
                    savedOrUpdatedGroup.visibility = group_visibility

                    savedOrUpdatedGroup.save()

                # print(f"Group created / saved: {savedOrUpdatedGroup}")

                # add members to group

                members = group.get('members', [])

                for member in members:
                    member_username = member['username']
                    member_access_level = member.get('access_level', 30)

                    print(f"Adding member: {member}")
                    print(f"Member username: {member_username}")
                    print(f"Member access level: {member_access_level}")

                    try:
                        user = gl.users.list(username=member_username)[0]

                        savedOrUpdatedGroup = savedOrUpdatedGroup.members.create({
                            'user_id': user.id,
                            'access_level': member_access_level
                        })
                    except Exception as e:
                        print(f"Error adding member: {str(e)}")

                    print(f"Group created / saved: {savedOrUpdatedGroup}")

            return {
                'changed': True,
                'msg': 'Successfully seeded GitLab instance',
                # 'projects': [project.name for project in projects]
            }

        except gitlab.exceptions.GitlabAuthenticationError as e:
            return {
                'failed': True,
                'msg': 'Authentication failed: {}'.format(str(e))
            }
        except Exception as e:
            return {
                'failed': True,
                'msg': 'An error occurred: {}'.format(str(e))
            }