part of 'password_reset_bloc.dart';

abstract class EmailEvent extends Equatable {
  const EmailEvent();

  @override
  List<Object> get props => [];
}

class SendEmailEvent extends EmailEvent {
  final String email;

  const SendEmailEvent(this.email);

  @override
  List<Object> get props => [email];
}
