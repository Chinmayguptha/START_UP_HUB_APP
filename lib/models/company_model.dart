import 'funding_model.dart';

class CompanyModel {
  final String id;
  final String name;
  final String domain;
  final String founder;
  final String location;
  final int yearFounded;
  final String stage;
  final String description;
  final String logoUrl;
  bool bookmarked;
  final List<FundingModel> fundingRounds;

  CompanyModel({
    required this.id,
    required this.name,
    required this.domain,
    required this.founder,
    required this.location,
    required this.yearFounded,
    required this.stage,
    required this.description,
    required this.logoUrl,
    this.bookmarked = false,
    required this.fundingRounds,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      name: json['name'],
      domain: json['domain'],
      founder: json['founder'],
      location: json['location'],
      yearFounded: json['yearFounded'],
      stage: json['stage'],
      description: json['description'],
      logoUrl: json['logoUrl'],
      bookmarked: json['bookmarked'] ?? false,
      fundingRounds: (json['fundingRounds'] as List)
          .map((e) => FundingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'domain': domain,
      'founder': founder,
      'location': location,
      'yearFounded': yearFounded,
      'stage': stage,
      'description': description,
      'logoUrl': logoUrl,
      'bookmarked': bookmarked,
      'fundingRounds': fundingRounds.map((e) => e.toJson()).toList(),
    };
  }
} 