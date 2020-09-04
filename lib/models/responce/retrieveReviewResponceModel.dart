
class RetrieveReview{
  int id;
  int product_id;
  String status;
  String reviewer;
  String review;
  int rating;


  RetrieveReview.fromJson(Map<String, dynamic> json):
        id = json['id'],
        product_id = json['product_id'],
        status = json['status'],
        reviewer = json['reviewer'],
        review = json['review'],
        rating = json['rating']
  {}

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'product_id': product_id,
        'status': status,
        'reviewer': reviewer,
        'review': review,
        'rating': rating,
      };
}
