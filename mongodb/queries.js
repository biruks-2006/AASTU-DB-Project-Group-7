// =============================================
// HOTEL MANAGEMENT SYSTEM - MongoDB Queries
// =============================================

db.reviews.deleteMany({});
db.roomServiceOrders.deleteMany({});
db.guestFeedback.deleteMany({});

db.reviews.insertMany([
  {
    guestName: "Biruk Alemu",
    bookingId: "B001",
    roomNumber: "A-101",
    overallRating: 4.8,
    roomRating: 5,
    serviceRating: 4.5,
    comment:
      "Excellent stay! The room was very clean and the staff was friendly. Highly recommended.",
    reviewDate: new Date("2026-04-20"),
    tags: ["clean", "friendly_staff", "good_location"],
  },
  {
    guestName: "Meron Tesfaye",
    bookingId: "B002",
    roomNumber: "B-205",
    overallRating: 4.2,
    roomRating: 4,
    serviceRating: 4.5,
    comment: "Good hotel but WiFi was a bit slow during peak hours.",
    reviewDate: new Date("2026-04-22"),
    tags: ["wifi_issue"],
  },
  {
    guestName: "Dawit Kebede",
    bookingId: "B003",
    roomNumber: "C-310",
    overallRating: 5,
    roomRating: 5,
    serviceRating: 5,
    comment: "Perfect experience! Will definitely come back again.",
    reviewDate: new Date("2026-04-25"),
    tags: ["perfect", "will_return"],
  },
]);

db.roomServiceOrders.insertMany([
  {
    guestId: "G001",
    bookingId: "B001",
    roomNumber: "A-101",
    orderDate: new Date("2026-04-25"),
    items: [
      { item: "Grilled Chicken", quantity: 1, price: 320 },
      { item: "French Fries", quantity: 2, price: 120 },
      { item: "Coca Cola", quantity: 2, price: 60 },
    ],
    totalAmount: 680,
    status: "Delivered",
    specialRequest: "Extra spicy on the chicken",
  },
  {
    guestId: "G002",
    bookingId: "B002",
    roomNumber: "B-205",
    orderDate: new Date("2026-04-22"),
    items: [
      { item: "Club Sandwich", quantity: 2, price: 180 },
      { item: "Orange Juice", quantity: 2, price: 80 },
    ],
    totalAmount: 520,
    status: "Delivered",
    specialRequest: "",
  },
]);

db.guestFeedback.insertMany([
  {
    guestName: "Dawit Kebede",
    bookingId: "B003",
    suggestions: "Add more variety in breakfast menu",
    rating: 4,
    submittedDate: new Date("2026-04-23"),
  },
  {
    guestName: "Meron Tesfaye",
    bookingId: "B002",
    suggestions: "Improve WiFi speed during evenings",
    rating: 4,
    submittedDate: new Date("2026-04-23"),
  },
]);

// =============================================
// READ QUERIES
// =============================================

// -----------------------------------------------
// Query 1: View All Reviews
// -----------------------------------------------
db.reviews.find().pretty();

// -----------------------------------------------
// Query 2: Reviews with Rating Above 4
// -----------------------------------------------
db.reviews.find({ overallRating: { $gt: 4 } });

// -----------------------------------------------
// Query 3: Reviews for a Specific Room
// -----------------------------------------------
db.reviews.find({ roomNumber: "A-101" });

// -----------------------------------------------
// Query 4: Average Overall Rating Across All Reviews
// -----------------------------------------------
db.reviews.aggregate([
  { $group: { _id: null, averageRating: { $avg: "$overallRating" } } },
]);

// -----------------------------------------------
// Query 5: Room Service Orders Sorted by Date
// -----------------------------------------------
db.roomServiceOrders.find().sort({ orderDate: -1 });

// -----------------------------------------------
// Query 6: Count Total Number of Reviews
// -----------------------------------------------
db.reviews.countDocuments();

// -----------------------------------------------
// Query 7: Update a Review Rating
// -----------------------------------------------
db.reviews.updateOne(
  { guestName: "Meron Tesfaye" },
  { $set: { overallRating: 4.5 } },
);

// -----------------------------------------------
// Query 8: Average Rating Broken Down by Room
// -----------------------------------------------
db.reviews.aggregate([
  {
    $group: {
      _id: "$roomNumber",
      averageRating: { $avg: "$overallRating" },
      totalReviews: { $sum: 1 },
    },
  },
  { $sort: { averageRating: -1 } },
]);

// -----------------------------------------------
// Query 9: Find All Orders for a Specific Booking
// -----------------------------------------------
db.roomServiceOrders.find({ bookingId: "B001" });

// -----------------------------------------------
// Query 10: Total Revenue from Room Service Orders
// -----------------------------------------------
db.roomServiceOrders.aggregate([
  {
    $group: {
      _id: null,
      totalServiceRevenue: { $sum: "$totalAmount" },
      totalOrders: { $sum: 1 },
    },
  },
]);

// -----------------------------------------------
// Query 11: All Guest Feedback Sorted by Rating
// -----------------------------------------------
db.guestFeedback.find().sort({ rating: -1 }).pretty();

// -----------------------------------------------
// Query 12: Reviews that Contain a Specific Tag
// -----------------------------------------------
db.reviews.find({ tags: "friendly_staff" });

// -----------------------------------------------
// Query 13: Delete a Review by ID
// -----------------------------------------------
db.reviews.deleteOne({ _id: "R001" });
