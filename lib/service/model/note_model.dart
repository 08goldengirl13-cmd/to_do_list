class NoteModel {
  String ? id;
  String title;
  String description;
  String status;
  String ? deadline;

  NoteModel({
    this.id,
    required this.title,
    required this.description,
     this.status = "Not Completed",
     this.deadline,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json){
    return NoteModel(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'],
      status: json['status'] ?? "Not Started",
      deadline: json['deadline'] ?? null,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "title": title,
      "description": description,
      "status": status,
      "deadline": deadline,
    };
  }
}
