import 'package:auth_repository/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeEntity {
  String recipeId;
  String title;
  String description;
  String imageUrl;
  List<Map<String, dynamic>> ingredients;
  List<Map<String, dynamic>> steps;
  DateTime createAt;
  MyUser myUser; // Dodane pole

  RecipeEntity({
    required this.recipeId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.createAt,
    required this.myUser, // Dodane pole
  });

  Map<String, Object?> toDocument() {
    return {
      'recipeId': recipeId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'steps': steps,
      'createAt': Timestamp.fromDate(createAt),
      'myUser': myUser.toEntity().toDocument(), // Dodane pole
    };
  }

  static RecipeEntity fromDocument(Map<String, dynamic> doc) {
    return RecipeEntity(
      recipeId: doc['recipeId'] as String,
      title: doc['title'] as String,
      description: doc['description'] as String,
      imageUrl: doc['imageUrl'] as String,
      ingredients: doc['ingredients'] as List<Map<String, dynamic>>,
      steps: doc['steps'] as List<Map<String, dynamic>>,
      createAt: (doc['createAt'] as Timestamp).toDate(),
      myUser: MyUser.fromEntity(
          MyUserEntity.fromDocument(doc['myUser'])), // Dodane pole
    );
  }

  @override
  List<Object?> get props => [
        recipeId,
        title,
        description,
        imageUrl,
        ingredients,
        steps,
        createAt,
        myUser
      ]; // Dodane pole

  @override
  String toString() {
    return '''RecipeEntity: {
      recipeId: $recipeId,
      title: $title,
      description: $description,
      imageUrl: $imageUrl,
      ingredients: $ingredients,
      steps: $steps,
      createAt: $createAt,
      myUser: $myUser // Dodane pole
    }''';
  }
}
