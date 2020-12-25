class TrieNode {
  String char;
  Map<String,TrieNode> children = {}; //map
  bool isLeafNode = false;
  bool isRoot;
  TrieNode parent;
  int distance;
  TrieNode(); //constructor
  TrieNode.withLetter(this.char); //constructor
  @override
  toString() => '($char, $children\n)';
}