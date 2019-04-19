/// An interface for hierarchical data.
abstract class TreeData {
  List<TreeData> get children;
}

/// Flattened representation of the tree, making it possible
/// to render the tree from virtualized (one dimensional) array.
class FlattenedTreeData {
  /// Reference back to the hierarchical node represented by this
  /// flat structure.
  final TreeData data;

  /// Whether this node has a sibling right after it
  bool hasNextSibling = false;

  /// Whether this node contains a child and hence must draw an extra line
  /// under itself to that child.
  bool hasNextChild = false;

  /// The list of horizontal spaces (indentation) and whether or not they
  /// contain a line.
  List<bool> lines = [];

  FlattenedTreeData(this.data);
}

/// Flatten the hierarchical tree and store properties necessary to help
/// define where connecting lines need to be drawn.
List<FlattenedTreeData> flattenTree(List<TreeData> list,
    [List<FlattenedTreeData> flattened, List<bool> depth]) {
  flattened ??= [];
  depth ??= [true];
  for (int i = 0; i < list.length; i++) {
    final item = list[i];
    final flat = FlattenedTreeData(item);
    flat.lines = depth;
    flattened.add(flat);
    flat.hasNextSibling = i != list.length - 1;
    flat.hasNextChild = item.children.isNotEmpty;
    if (item.children.isNotEmpty) {
      List<bool> childDepth = List<bool>.from(depth);
      if (!flat.hasNextSibling && childDepth.length != 1) {
        childDepth[childDepth.length - 1] = false;
      }
      childDepth.add(true);
      flattenTree(item.children, flattened, childDepth);
    }
  }
  return flattened;
}
