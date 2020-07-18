class Category {
  final String id;
  final String name;
  final String photo;
  final String colorCode;
  final String colorDarkCode;
  final String colorLightCode;

  const Category({
    this.id,
    this.name,
    this.photo,
    this.colorCode,
    this.colorDarkCode,
    this.colorLightCode,
  });

  @override
  String toString() {
    // TODO: implement toString
    return "{id: ${this.id}, name: ${this.name}, color: ${this.colorCode}, photo: ${this.photo}}";
  }
}
