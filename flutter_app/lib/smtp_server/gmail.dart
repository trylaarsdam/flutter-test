import '../smtp_server.dart';

SmtpServer gmail(String username, String password) =>
    new SmtpServer('smtp.gmail.com', username: username, password: password);
