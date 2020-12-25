import 'dart:core';
import 'dart:math';
import 'trie_node.dart';

class Trie {
  TrieNode root;
  Trie() {
    root = TrieNode();
    root.isRoot = true;
  }
  //returns map with all the words that are similar to the param. word together with the distance
  Map<String, TrieNode> search(String word, int maxDistance){
    var currentRow = List<int>(word.length+1);
    var results = <String,TrieNode>{}; //map
    for(var j=0;j<currentRow.length;j++){
      currentRow[j] = j;
    }
    for(var letter in root.children.keys){
      results = searchRecursive(root.children[letter], letter, word, currentRow, results, maxDistance);
    }
    return results;
  }
  //calls search function but instead of returning a map it only returns the word with the smallest distance.
  String searchForOneItem(String word, int maxDistance){
    MapEntry<String, TrieNode> min;
    var res = search(word, maxDistance);
    if(res.length == 1){
      return buildWord(res.values.first);
    }
    String result;
    for(MapEntry entry in res.entries){
      TrieNode node = entry.value;
      if(min == null || node.distance < min.value.distance){
        min = entry;
      }
    }
    if(min == null){
      return 'no name found';
    }
    result = buildWord(min.value);
    return result;
  }
  //function should only get called via search() func.
  Map<String,TrieNode> searchRecursive(TrieNode node, String letter, String word, List<int> prevRow, Map<String,TrieNode> results, int maxDistance){
    var columns = word.length+1;
    var currRow = <int>[prevRow[0]+1]; //list

    //Build one row for the letter, with a column for each letter in the target word, plus one for the empty string at column 0
    int insertCost,deleteCost,replaceCost;
    for(var column=1;column<columns;column++){
      insertCost = currRow[column-1]+1;
      deleteCost = prevRow[column]+1;
      if(word[column-1] != letter) {
        replaceCost = prevRow[column-1]+1;
      }
      else {
        replaceCost = prevRow[column-1];
      }

      currRow.add(findMin(insertCost,deleteCost,replaceCost));

    }

    //if the last entry in the row indicates the optimal cost is less than the maximum cost, and there is a word in this trie node, then add it.
    if(currRow[currRow.length-1] <= maxDistance && node.isLeafNode){
      node.distance = currRow[currRow.length-1];
      results.putIfAbsent(buildWord(node), () => node );
    }
    //if any entries in the row are less than the maximum cost, then recursively search each branch of the trie
    if(currRow.reduce(min) <= maxDistance){
      for(var letter in node.children.keys){
        searchRecursive(node.children[letter], letter, word, currRow, results, maxDistance);
      }
    }
    return results;
  }
  //returns a list with all the words that start with the word param.
  List<String> autoComplete(String word){
    var list =  <String>[]; //list
    var node = searchNode(word);
    if(node != null){
      list = recursiveForAutoComplete(node, list);
    }
    return list;
  }
  //function should only get called via autoComplete() func.
  List<String> recursiveForAutoComplete(TrieNode node, List<String> list){
    var ret = list;
    for(var child in node.children.values){
      if(child.isLeafNode){
        ret.add(buildWord(child));
      }
      recursiveForAutoComplete(child, ret);
    }
    return ret;
  }
  //adds a word to the trie
  void add(String word) {
    Map children = root.children;
    var currParent = root;

    for (var i = 0; i < word.length; i++) {
      var c = word[i];
      TrieNode node;
      if (children.containsKey(c)) {
        node = children[c];
      }
      else {
        node = TrieNode.withLetter(c);
        node.isRoot = false;
        node.parent = currParent;
        //root.children[c] = node;
        children.putIfAbsent(c, () => node);
      }
      children = node.children;
      currParent = node;

      if (i == word.length - 1) {
        node.isLeafNode = true;
      }
    }
  }
  //search for one node in the trie tree
  TrieNode searchNode(String word) {
    TrieNode node;
    var children = root.children;
    for (var i = 0; i < word.length; i++) {
      var c = word[i];
      if (children.containsKey(c)) {
        node = children[c];
        children = node.children;
      }
      else {
        return null;
      }
    }

    return node;
  }
  //builds the word by adding the chars
  String buildWord(TrieNode node){
    var currParent = node.parent;
    var actualWord = node.char;
    while(currParent != null){
      if(currParent.parent != null){
        actualWord += currParent.char;
      }
      currParent = currParent.parent;
    }
    return reverseString(actualWord);
  }
  //needed to print
  String reverseString(String s) {
    var sb = StringBuffer();
    for(var i = s.length - 1; i >= 0; --i) {
      sb.write(s[i]);
    }
    return sb.toString();
  }
  //needed to calc the min distance for levenshtein
  int findMin(int x, int y, int z){
    if(x <= y && x <= z) {
      return x;
    }
    if(y <= x && y <= z) {
      return y;
    }
    else {
      return z;
    }
  }

}
