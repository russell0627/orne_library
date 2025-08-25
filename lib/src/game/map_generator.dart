import 'dart:math';
import 'package:orne_library/src/game/tile_type.dart';

/// A container for a generated map layout and player start position.
class MapLayout {
  final List<List<TileType>> grid;
  final Point<int> playerStartPosition;

  MapLayout(this.grid, this.playerStartPosition);
}

/// Procedurally generates different map layouts for the library.
class MapGenerator {
  final Random _random = Random();
  static const int gridWidth = 50;
  static const int gridHeight = 50;

  /// Generates one of five possible map layouts at random.
  MapLayout generate() {
    final layoutId = _random.nextInt(4);
    switch (layoutId) {
      case 0:
        return _buildCentralHallLayout();
      case 1:
        return _buildSpineLayout();
      case 2:
        return _buildQuadrantLayout();
      case 3:
      default:
        return _buildClusteredLayout();
    }
  }

  /// Creates a grid completely filled with wall tiles.
  List<List<TileType>> _createBaseGrid() {
    return List.generate(
      gridHeight,
      (_) => List.generate(gridWidth, (_) => TileType.Wall),
    );
  }

  /// Carves a room into the grid and places a special tile in its center.
  void _drawRoom(
      List<List<TileType>> grid, int x, int y, int w, int h, TileType special) {
    for (int j = y; j < y + h; j++) {
      for (int i = x; i < x + w; i++) {
        if (j >= 0 && j < gridHeight && i >= 0 && i < gridWidth) {
          grid[j][i] = TileType.Floor;
        }
      }
    }
    // Place the special tile in the middle of the room
    grid[y + h ~/ 2][x + w ~/ 2] = special;
  }

  /// Places a door tile at a specific coordinate.
  void _placeDoor(List<List<TileType>> grid, int x, int y) {
    if (y >= 0 && y < gridHeight && x >= 0 && x < gridWidth) {
      grid[y][x] = TileType.Door;
    }
  }

  /// Layout 1: A large central hall with wings.
  MapLayout _buildCentralHallLayout() {
    var grid = _createBaseGrid();
    final playerStart = Point(25, 45);

    // Central Great Hall
    _drawRoom(grid, 15, 15, 20, 20, TileType.GreatHall);

    // Entrance Area
    _drawRoom(grid, 23, 35, 5, 10, TileType.EntranceHall);
    _placeDoor(grid, 25, 35);
    _drawRoom(grid, 18, 40, 5, 5, TileType.MainReadingRoom);
    _drawRoom(grid, 28, 40, 5, 5, TileType.RestrictedSection);
    _placeDoor(grid, 23, 42);
    _placeDoor(grid, 27, 42);

    // West Wing
    _drawRoom(grid, 5, 15, 10, 5, TileType.PeriodicalsArchive);
    _drawRoom(grid, 5, 20, 10, 5, TileType.FolioWing);
    _drawRoom(grid, 5, 25, 10, 5, TileType.FoundersPortraitGallery);
    _placeDoor(grid, 15, 17);
    _placeDoor(grid, 15, 22);
    _placeDoor(grid, 15, 27);

    // East Wing
    _drawRoom(grid, 35, 15, 10, 8, TileType.CartographyDepartment);
    _drawRoom(grid, 35, 23, 10, 8, TileType.AcquisitionsDepartment);
    _placeDoor(grid, 35, 18);
    _placeDoor(grid, 35, 26);

    // North Wing
    _drawRoom(grid, 15, 5, 8, 10, TileType.TheOrrery);
    _drawRoom(grid, 23, 5, 8, 10, TileType.SpecialCollections);
    _placeDoor(grid, 18, 15);
    _placeDoor(grid, 26, 15);

    // Scattered Rooms
    grid[16][16] = TileType.RareBookRoom;
    grid[33][33] = TileType.TheLanternRoom;
    grid[10][10] = TileType.ManuscriptVault;
    grid[40][10] = TileType.BindingAndRestoration;
    grid[10][40] = TileType.TranslationOffice;
    grid[40][40] = TileType.MicroficheAnnex;
    grid[2][2] = TileType.JanitorialCloset;
    grid[47][47] = TileType.JanitorialCloset;
    grid[2][47] = TileType.HiddenChamber;
    grid[30][10] = TileType.StudyCarrels;
    grid[20][2] = TileType.EchoingStairwell;

    return MapLayout(grid, playerStart);
  }

  /// Layout 2: A long vertical spine with rooms branching off.
  MapLayout _buildSpineLayout() {
    var grid = _createBaseGrid();
    final playerStart = Point(25, 45);

    // Main Spine (Echoing Stairwell)
    for (int y = 5; y < 45; y++) {
      _drawRoom(grid, 24, y, 3, 1, TileType.Floor);
    }
    grid[25][25] = TileType.EchoingStairwell;

    // Entrance
    _drawRoom(grid, 23, 44, 5, 5, TileType.EntranceHall);
    _placeDoor(grid, 25, 44);

    // Rooms off the spine
    _drawRoom(grid, 15, 5, 8, 8, TileType.TheOrrery);
    _placeDoor(grid, 24, 8);
    _drawRoom(grid, 30, 5, 8, 8, TileType.TheLanternRoom);
    _placeDoor(grid, 26, 8);

    _drawRoom(grid, 10, 15, 14, 5, TileType.GreatHall);
    _placeDoor(grid, 24, 17);

    _drawRoom(grid, 30, 15, 10, 10, TileType.MainReadingRoom);
    _placeDoor(grid, 26, 20);

    _drawRoom(grid, 5, 25, 19, 5, TileType.FoundersPortraitGallery);
    _placeDoor(grid, 24, 27);

    _drawRoom(grid, 30, 28, 15, 5, TileType.RestrictedSection);
    _placeDoor(grid, 26, 30);

    _drawRoom(grid, 10, 35, 14, 5, TileType.PeriodicalsArchive);
    _placeDoor(grid, 24, 37);

    // Other rooms
    grid[16][10] = TileType.SpecialCollections;
    grid[35][10] = TileType.RareBookRoom;
    grid[10][22] = TileType.FolioWing;
    grid[40][25] = TileType.MicroficheAnnex;
    grid[15][30] = TileType.StudyCarrels;
    grid[35][38] = TileType.CartographyDepartment;
    grid[5][40] = TileType.AcquisitionsDepartment;
    grid[45][5] = TileType.BindingAndRestoration;
    grid[45][45] = TileType.TranslationOffice;
    grid[2][2] = TileType.ManuscriptVault;
    grid[47][2] = TileType.HiddenChamber;
    grid[2][47] = TileType.JanitorialCloset;

    return MapLayout(grid, playerStart);
  }

  /// Layout 3: Four distinct quadrants.
  MapLayout _buildQuadrantLayout() {
    var grid = _createBaseGrid();
    final playerStart = Point(25, 45);

    // Separating Walls
    for (int y = 0; y < gridHeight; y++) grid[y][25] = TileType.Wall;
    for (int x = 0; x < gridWidth; x++) grid[25][x] = TileType.Wall;

    // Doors
    _placeDoor(grid, 25, 12);
    _placeDoor(grid, 25, 37);
    _placeDoor(grid, 12, 25);
    _placeDoor(grid, 37, 25);

    // Entrance
    _drawRoom(grid, 22, 40, 7, 9, TileType.EntranceHall);
    _placeDoor(grid, 25, 40);

    // Top-Left (Archives)
    _drawRoom(grid, 5, 5, 15, 8, TileType.PeriodicalsArchive);
    _drawRoom(grid, 5, 15, 8, 8, TileType.MicroficheAnnex);
    _drawRoom(grid, 15, 15, 8, 8, TileType.FolioWing);
    grid[2][2] = TileType.AcquisitionsDepartment;
    grid[23][2] = TileType.TranslationOffice;

    // Top-Right (Esoteric)
    _drawRoom(grid, 30, 5, 15, 15, TileType.TheOrrery);
    _drawRoom(grid, 30, 20, 8, 4, TileType.SpecialCollections);
    _drawRoom(grid, 40, 20, 8, 4, TileType.ManuscriptVault);
    grid[2][47] = TileType.HiddenChamber;
    grid[23][47] = TileType.RestrictedSection;

    // Bottom-Left (Study)
    _drawRoom(grid, 5, 30, 15, 15, TileType.MainReadingRoom);
    _drawRoom(grid, 5, 26, 8, 4, TileType.StudyCarrels);
    _drawRoom(grid, 15, 26, 8, 4, TileType.RareBookRoom);
    grid[47][2] = TileType.BindingAndRestoration;
    grid[27][2] = TileType.TheLanternRoom;

    // Bottom-Right (Grand)
    _drawRoom(grid, 30, 30, 15, 15, TileType.GreatHall);
    _drawRoom(grid, 30, 26, 8, 4, TileType.FoundersPortraitGallery);
    _drawRoom(grid, 40, 26, 8, 4, TileType.EchoingStairwell);
    grid[47][47] = TileType.JanitorialCloset;
    grid[27][47] = TileType.CartographyDepartment;

    return MapLayout(grid, playerStart);
  }

  /// Layout 5: Organic clusters of rooms.
  MapLayout _buildClusteredLayout() {
    var grid = _createBaseGrid();
    final playerStart = Point(25, 45);

    // Entrance Cluster
    _drawRoom(grid, 22, 40, 7, 9, TileType.EntranceHall);
    _drawRoom(grid, 15, 38, 7, 7, TileType.MainReadingRoom);
    _drawRoom(grid, 29, 38, 7, 7, TileType.RestrictedSection);
    _placeDoor(grid, 22, 42);
    _placeDoor(grid, 28, 42);
    _placeDoor(grid, 25, 40);

    // Central Cluster
    _drawRoom(grid, 20, 20, 11, 11, TileType.GreatHall);
    _drawRoom(grid, 18, 18, 3, 3, TileType.TheLanternRoom);
    _drawRoom(grid, 30, 18, 3, 3, TileType.RareBookRoom);
    _drawRoom(grid, 18, 30, 3, 3, TileType.EchoingStairwell);
    _drawRoom(grid, 30, 30, 3, 3, TileType.FoundersPortraitGallery);
    _placeDoor(grid, 25, 31);
    _placeDoor(grid, 25, 20);

    // Top-Left Cluster (Scholarly)
    _drawRoom(grid, 5, 5, 10, 10, TileType.PeriodicalsArchive);
    _drawRoom(grid, 1, 10, 4, 4, TileType.StudyCarrels);
    _drawRoom(grid, 10, 1, 4, 4, TileType.FolioWing);
    _placeDoor(grid, 10, 15);
    _placeDoor(grid, 15, 10);

    // Top-Right Cluster (Esoteric)
    _drawRoom(grid, 35, 5, 10, 10, TileType.TheOrrery);
    _drawRoom(grid, 31, 1, 4, 4, TileType.SpecialCollections);
    _drawRoom(grid, 45, 10, 4, 4, TileType.ManuscriptVault);
    _placeDoor(grid, 35, 10);
    _placeDoor(grid, 40, 15);

    // Bottom-Left Cluster (Logistics)
    _drawRoom(grid, 5, 25, 10, 10, TileType.AcquisitionsDepartment);
    _drawRoom(grid, 1, 25, 4, 4, TileType.CartographyDepartment);
    _drawRoom(grid, 10, 35, 4, 4, TileType.BindingAndRestoration);
    _placeDoor(grid, 10, 25);

    // Bottom-Right Cluster (Translation)
    _drawRoom(grid, 35, 25, 10, 10, TileType.TranslationOffice);
    _drawRoom(grid, 45, 25, 4, 4, TileType.MicroficheAnnex);
    _placeDoor(grid, 35, 30);

    // Hidden Rooms
    grid[2][47] = TileType.HiddenChamber;
    grid[47][2] = TileType.JanitorialCloset;

    return MapLayout(grid, playerStart);
  }
}