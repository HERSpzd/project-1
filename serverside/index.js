const express = require("express");
const cors = require("cors");
const bodyparser = require("body-parser");
const healthcareAPI = require("./controllerAPI/api-controller"); // Introduce routing

const app = express();

// Enable cors
app.use(cors());

// Configure body parser
app.use(bodyparser.json({ limit: "2100000kb" }));
app.use(bodyparser.urlencoded({ extended: false }));

// Using Routing
app.use("/api/homecare", healthcareAPI);

// Error handling middleware
app.use((err, req, res, next) => {
  if (err.name === "UnauthorizedError") {
    res
      .status(401)
      .json({ success: false, message: "Invalid authentication token" });
  } else {
    next(err);
  }
});

// Start the server on port 3060
const port = 3060;
app.listen(port, () => {
  console.log(`Server up and running on port ${port}`);
});
