import 'package:test/test.dart';
import 'package:yade_cli/src/utils/path_util.dart';

void main() {
  test('test util', () {
    // arrange
    const repoUrl = 'ssh://git.example.com:2222/group/example-one.git';

    // act
    var repoName = gitRepoName(repoUrl);

    // assert repo name without extension
    expect(repoName, 'example-one');

    // act
    repoName = gitRepoName(repoUrl, withExtension: true);

    // assert repo name with extension
    expect(repoName, 'example-one.git');
  });
}
