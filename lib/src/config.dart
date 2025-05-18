//camera sizes
const cameraWidth = 800.0;
const cameraHeight = 1600.0;

//play area sizes
const playWidth = cameraWidth;
const playHeight = 30000.0;

const gravityY = 1000.0;

// Bricks
const brickWidth = 100.0;
const brickHeight = 25.0;
const brickSpawnSeparation = 200.0; //Easy
const brickSpawnSeparationMedium = 300.0; //Normal
const brickSpawnSeparationHard = 400.0; //Hard
const brickRenderHeights = [];
const brickVelocity = 1000.0;

// Booster
const boosterWidth = 40.0;
const boosterHeight = 40.0;
const boosterSpawnSeparation = 4000.0; //Easy
const boosterSpawnSeparationMedium = 5000.0; //Normal
const boosterSpawnSeparationHard = 5500.0; //Hard
const boosterVelocity = 1800.0; //Easy
const boosterVelocityMedium = 1650.0; //Normal
const boosterVelocityHard = 1500.0; //Hard

// Goal
const goalWidth = 64.0;
const goalHeight = 64.0;

// Trap
const trapWidth = 64.0;
const trapheight = 64.0;
const trapSpawnSeparation = 800.0; //Easy
const trapSpawnSeparationMedium = 700.0; //Normal
const trapSpawnSeparationHard = 400.0; //Hard

// Spring
const springHeight = 64.0;
const springWidth = 64.0;
const springVelocity = 500.0;
const springSpawnSeparation = 1800.0; //Easy
const springSpawnSeparationMedium = 1500.0; // Normal
const springSpawnSeparationHard = 1000.0; // Hard

class LevelModifier {
  int difficulty;
  double boosterVelocity;
  double boosterSpawnSeparation;
  double brickSpawnSeparation;
  double trapSpawnSeparation;
  double springSpawnSeparation;

  LevelModifier(
      {this.difficulty = 0,
      this.boosterVelocity = 0,
      this.boosterSpawnSeparation = 0,
      this.brickSpawnSeparation = 0,
      this.trapSpawnSeparation = 0,
      this.springSpawnSeparation = 0});
}
