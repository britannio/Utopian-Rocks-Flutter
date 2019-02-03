class GithubModel {
  final String tagName;
  final String htmlUrl;

  GithubModel(this.tagName, this.htmlUrl);

  GithubModel.fromJson(Map json)
      : this.tagName = json['tag_name'],
        this.htmlUrl = json['html_url'];
}