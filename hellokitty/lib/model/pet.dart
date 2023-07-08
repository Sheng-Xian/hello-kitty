class Pet {
  String image;
  String name;
  String age;
  String gender;
  String target_weight;
  String advice;

  // Constructor
  Pet({
    required this.image,
    required this.name,
    required this.age,
    required this.gender,
    required this.target_weight,
    required this.advice,
  });

  Pet copy({
    String? imagePath,
    String? name,
    String? gender,
    String? target_weight,
    String? advice,
  }) =>
      Pet(
        image: imagePath ?? this.image,
        name: name ?? this.name,
        age: age ?? this.age,
        gender: gender ?? this.gender,
        target_weight: target_weight ?? this.target_weight,
        advice: advice ?? this.advice,
      );

  static Pet fromJson(Map<String, dynamic> json) => Pet(
        image: json['imagePath'],
        name: json['name'],
        age: json['age'],
        gender: json['gender'],
        target_weight: json['target_weight'],
        advice: json['advice'],
      );

  Map<String, dynamic> toJson() => {
        'imagePath': image,
        'name': name,
        'age': age,
        'gender': gender,
        'target_weight': target_weight,
        'advice': advice,
      };
}
