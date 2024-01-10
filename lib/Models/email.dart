class Email {
  String _sendTo = "";
  String _emailSubject = "";
  String _emailBody = "";

  Email({
    required String sednTo,
    required String emailSubject,
    required String emailBody,
  }) {
    _sendTo = sednTo;
    _emailSubject = emailSubject;
    _emailBody = emailBody;
  }

  String getSendTo() => _sendTo;
  String getSubject() => _emailSubject;
  String getBody() => _emailBody;
}
