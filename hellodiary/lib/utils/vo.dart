class Version {
  String version;
  String changeLog;
  String releaseURL;

  Version(this.version, this.changeLog, this.releaseURL);

  Version.fromMap(Map<String, dynamic> map)
      : this(map['version'], map['changeLog'],map['releaseURL']);

  @override
  String toString() {
    return 'Version{version: $version, changeLog: $changeLog, releaseURL: $releaseURL}';
  }
}

class Advertisement {
  int displayTime;
  String tapUrl;
  String mediaUrl;

  Advertisement(this.displayTime, this.tapUrl, this.mediaUrl);

  Advertisement.fromMap(Map<String, dynamic> map)
      : this(map['displayTime'], map['tapUrl'],map['mediaUrl']);

  @override
  String toString() {
    return 'Advertisement{displayTime: $displayTime, tapUrl: $tapUrl, mediaUrl: $mediaUrl}';
  }
}