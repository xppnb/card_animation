class Card3D {
  final String title;
  final String author;
  final String image;

  Card3D({this.title, this.author, this.image});
}

const _path = "images";

final cardList = [
  Card3D(
      author: "Troye Sivan",
      title: "Blue Neighbourhood",
      image: "$_path/1.jpg"),
  Card3D(author: "Bundii xxxx", title: "The Escape", image: "$_path/2.jpg"),
  Card3D(author: "Queen", title: "Bohemian Rhapsody", image: "$_path/3.jpg"),
  Card3D(author: "Ed Sheran", title: "Perfect", image: "$_path/4.jpg"),
  Card3D(author: "Ryan Jones", title: "Pain", image: "$_path/5.jpg")
];
