class Category {
  final String id;
  final String name;
  String photo;
  final String colorCode;
  final String colorLightCode;

  Category({
    this.id,
    this.name,
    this.photo,
    this.colorCode,
    this.colorLightCode,
  });

  @override
  String toString() {
    // TODO: implement toString
    return "{id: ${this.id}, name: ${this.name}, color: ${this.colorCode}, photo: ${this.photo}}";
  }
}
