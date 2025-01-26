String capitalizeWords(String input) {
  List<String> words = input.split(' ');
  List<String> capitalizedWords = [];

  for (String word in words) {
    if (word.isNotEmpty) {
      capitalizedWords
          .add('${word[0].toUpperCase()}${word.substring(1).toLowerCase()}');
    } else {
      capitalizedWords.add(word);
    }
  }
  return capitalizedWords.join(' ');
}
