import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'email_event.dart';
part 'email_state.dart';

class EmailBloc extends Bloc<EmailEvent, EmailState> {
  final FirebaseAuth _firebaseAuth;

  EmailBloc(this._firebaseAuth) : super(EmailInitial()) {
    on<SendEmailEvent>(_onSendEmailEvent);
  }

  Future<void> _onSendEmailEvent(
      SendEmailEvent event, Emitter<EmailState> emit) async {
    emit(EmailSending());
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: event.email);
      emit(EmailSentSuccess());
    } catch (e) {
      emit(EmailSentFailure(errorMessage: e.toString()));
    }
  }
}
