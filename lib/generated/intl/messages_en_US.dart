// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en_US locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en_US';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appName": MessageLookupByLibrary.simpleMessage("Labyrinth"),
        "birth": MessageLookupByLibrary.simpleMessage("DOB"),
        "country": MessageLookupByLibrary.simpleMessage("Country"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "emailEmpty":
            MessageLookupByLibrary.simpleMessage("The email is empty"),
        "emailNotMatch":
            MessageLookupByLibrary.simpleMessage("The email is not match"),
        "emptyValue":
            MessageLookupByLibrary.simpleMessage("The content is empty"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "female": MessageLookupByLibrary.simpleMessage("Female"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
        "gender": MessageLookupByLibrary.simpleMessage("Gender"),
        "information": MessageLookupByLibrary.simpleMessage("Information"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "male": MessageLookupByLibrary.simpleMessage("Male"),
        "notAccount": MessageLookupByLibrary.simpleMessage(
            "If you have not account yet?"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordEmpty":
            MessageLookupByLibrary.simpleMessage("The password is empty"),
        "passwordLess": MessageLookupByLibrary.simpleMessage(
            "The password length should be over 6 characters"),
        "processingWaring":
            MessageLookupByLibrary.simpleMessage("Processing now..."),
        "rePassword": MessageLookupByLibrary.simpleMessage("Re-Password"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "send": MessageLookupByLibrary.simpleMessage("Send"),
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "userID": MessageLookupByLibrary.simpleMessage("User ID"),
        "verifyCode": MessageLookupByLibrary.simpleMessage("Verify Code"),
        "waring": MessageLookupByLibrary.simpleMessage("Waring")
      };
}