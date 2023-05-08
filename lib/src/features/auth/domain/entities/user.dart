import 'package:equatable/equatable.dart';


class User extends Equatable {
  
  const User({
    required this.email,
    required this.id,
    required this.name, 
    required this.photo,
  });

  final String id;
  final String email;
  final String name;
  final String photo;

  @override
  List<Object?> get props => [id, email, name, photo];
}