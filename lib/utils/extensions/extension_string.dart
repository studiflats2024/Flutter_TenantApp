extension ConcatenateAsterisk on String {
  String get concatenateAsterisk {
    return "$this *";
  }
}

extension ConcatenateColumn on String {
  String get concatenateColumn {
    return "$this:";
  }
}

extension ConcatenateExclamation on String {
  String get concatenateExclamation {
    return "$this!";
  }
}

extension ConcatenateComma on String {
  String get concatenateComma {
    return "$this,";
  }
}

extension ConcatenateDash on String {
  String get concatenateDash {
    return "$this-";
  }
}

extension ConcatenateSpace on String {
  String get concatenateSpace {
    return "$this ";
  }
}

extension ConcatenateNewLine on String {
  String get concatenateNewline {
    return "$this\n";
  }
}

extension ConcatenateBrackets on String {
  String get concatenateBrackets {
    return "($this)";
  }
}

extension ConcatenateQuestionMarkEnglish on String {
  String get concatenateQuestionMarkEnglish {
    return "$this?";
  }
}

extension ConcatenateDollarSign on String {
  String get concatenateDollarSign {
    return "\$$this";
  }
}

extension ConcatenateQuestionMarkArabic on String {
  String get concatenateQuestionMarkArabic {
    return "$this؟";
  }
}

extension Validation on String? {
  bool get isNullOrEmpty => (this != null && this!.isNotEmpty) ? false : true;
}

extension StringExtension on String {
  String get capitalize {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  bool get isLink {
    return contains("https") || contains("http");
  }
}
extension TextMask on String {
   String get emailMask{
     final parts = this.split('@');
     final localPart = parts[0];
     final domain = parts[1];
      String maskedLocal ='';
     if(localPart.length > 4){
        maskedLocal = '*' * (localPart.length - 4) + localPart.substring(localPart.length - 4);
     }else{
       maskedLocal ='*' * (localPart.length );
     }
     return '$maskedLocal@$domain';
  }

  String get phoneMask{
    final visibleStart = this.substring(0, 3); // First 3 digits
    final visibleEnd = this.substring(this.length - 2); // Last 2 digits
    final maskedMiddle = '*' * (this.length - 5); // Replace middle digits with '*'
    return '$visibleStart$maskedMiddle$visibleEnd';
  }

}
extension ArabicNumberConverter on String {
  static const Map<String, String> arabicDigits = <String, String>{
    '0': '\u0660',
    '1': '\u0661',
    '2': '\u0662',
    '3': '\u0663',
    '4': '\u0664',
    '5': '\u0665',
    '6': '\u0666',
    '7': '\u0667',
    '8': '\u0668',
    '9': '\u0669',
  };




  String toArabicDigitsConverter() {
    final String number = toString();
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < number.length; i++) {
      sb.write(arabicDigits[number[i]] ?? number[i]);
    }
    return sb.toString();
  }
}
