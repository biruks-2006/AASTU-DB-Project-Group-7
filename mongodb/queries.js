// =============================================
// HOTEL MANAGEMENT SYSTEM - MongoDB Queries
// =============================================

use("hotel_management");

// ====================== INSERT SAMPLE DATA ======================

// Sample Reviews
db.reviews.insertMany([
  {
    guestName: "Biruk Alemu",
    bookingId: "B001",
    roomNumber: "A-101",
    overallRating: 4.8,
    roomRating: 5,
    serviceRating: 4.5,
    comment:
      "Excellent stay! The room was very clean and the staff was friendly.",
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
]);

// Sample Room Service Orders
db.roomServiceOrders.insertMany([
  {
    guestId: "G123",
    bookingId: "B001",
    roomNumber: "A-101",
    orderDate: new Date("2026-04-25"),
    items: [
      { item: "Grilled Chicken", quantity: 1, price: 320 },
      { item: "French Fries", quantity: 2, price: 120 },
    ],
    totalAmount: 680,
    status: "Delivered",
  },
]);

// ====================== IMPORTANT QUERIES ======================

// 1. Show all reviews
db.reviews.find().pretty();

// 2. High rated reviews (greater than 4)
db.reviews.find({ overallRating: { $gt: 4 } });

// 3. Reviews for a specific room
db.reviews.find({ roomNumber: "A-101" });

// 4. Average hotel rating
db.reviews.aggregate([
  { $group: { _id: null, averageRating: { $avg: "$overallRating" } } },
]);

// 5. Recent room service orders
db.roomServiceOrders.find().sort({ orderDate: -1 });

// 6. Total number of reviews
db.reviews.countDocuments();

// ====================== UPDATE EXAMPLE ======================
db.reviews.updateOne(
  { guestName: "Meron Tesfaye" },
  { $set: { overallRating: 4.5 } },
);
