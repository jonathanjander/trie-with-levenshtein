import 'trie_data_structure.dart';
List<String> testList = [
  'joe',
  'john',
  'johny',
  'johnny',
  'jane',
  'jack',
  'lane',
  'tone'
];
void main() {
  var trie = Trie();
  for(var name in testList){
    trie.add(name);
  }
  trie.search('lane', 2).forEach((key, value) {
    print('$key with ${value.distance} distance');
  });

}
