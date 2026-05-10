import 'package:flutter/material.dart';
import 'package:stayyoung/core/utils/brain_score_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/game_ready_phase.dart';
import '../widgets/game_memorise_phase.dart';
import '../widgets/game_recall_phase.dart';
import '../widgets/game_result_phase.dart';

enum GamePhase { ready, memorise, recall, result }

class WordRecallScreen extends StatefulWidget {
  const WordRecallScreen({super.key});

  @override
  State<WordRecallScreen> createState() => _WordRecallScreenState();
}

class _WordRecallScreenState extends State<WordRecallScreen> {
  GamePhase _phase = GamePhase.ready;

  // The 6 words the user must memorise — shuffled each round
  List<String> _targetWords = [];

  // The full grid shown during recall (target words + decoys mixed)
  List<String> _allWords = [];

  // Words the user has tapped during recall
  final Set<String> _selectedWords = {};

  // Full word bank to draw from
  static const List<String> _wordBank = [
    'Ocean',
    'Candle',
    'Bridge',
    'Lemon',
    'Mirror',
    'Garden',
    'Forest',
    'Pencil',
    'Flower',
    'Clock',
    'Stone',
    'Window',
    'Bottle',
    'Silver',
    'Carpet',
    'Pillow',
    'Basket',
    'Thunder',
    'Planet',
    'Lantern',
    'Feather',
    'Marble',
    'Cactus',
    'Fossil',
    'Ribbon',
    'Compass',
    'Anchor',
    'Whistle',
    'Pebble',
    'Jungle',
  ];

  static const int _targetCount = 6;
  static const int _decoyCount = 6;

  // ── Game setup ─────────────────────────────────────────────
  void _setupRound() {
    final shuffled = List<String>.from(_wordBank)..shuffle();
    _targetWords = shuffled.take(_targetCount).toList();

    final decoys = shuffled.skip(_targetCount).take(_decoyCount).toList();
    _allWords = [..._targetWords, ...decoys]..shuffle();
    _selectedWords.clear();
  }

  // ── Phase transitions ──────────────────────────────────────
  void _startGame() {
    _setupRound();
    setState(() => _phase = GamePhase.memorise);
  }

  void _onMemoriseComplete() {
    setState(() => _phase = GamePhase.recall);
  }

  void _onWordToggled(String word) {
    setState(() {
      if (_selectedWords.contains(word)) {
        _selectedWords.remove(word);
      } else {
        _selectedWords.add(word);
      }
    });
  }

  Future<void> _onCheckAnswers() async {
    await BrainScoreHelper.updateScoreAfterGame(
      correctCount: _correctCount,
      totalCount: _targetWords.length,
    );
    setState(() => _phase = GamePhase.result);
  }

  void _onPlayAgain() {
    setState(() => _phase = GamePhase.ready);
  }

  // ── Score helpers ──────────────────────────────────────────
  int get _correctCount =>
      _selectedWords.where((w) => _targetWords.contains(w)).length;

  int get _wrongCount =>
      _selectedWords.where((w) => !_targetWords.contains(w)).length;

  int get _missedCount =>
      _targetWords.where((w) => !_selectedWords.contains(w)).length;

  // ── Build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(child: _buildPhase()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: 4),
          Text('Word Recall', style: AppTextStyles.headingSmall),
          const Spacer(),
          // Phase indicator pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceWarm,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _phaseLabel,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primaryDark,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _phaseLabel {
    switch (_phase) {
      case GamePhase.ready:
        return '🧩 Get ready';
      case GamePhase.memorise:
        return '👁 Memorise';
      case GamePhase.recall:
        return '🧠 Recall';
      case GamePhase.result:
        return '🎉 Result';
    }
  }

  Widget _buildPhase() {
    switch (_phase) {
      case GamePhase.ready:
        return GameReadyPhase(onStart: _startGame);

      case GamePhase.memorise:
        return GameMemorisePhase(
          words: _targetWords,
          onComplete: _onMemoriseComplete,
        );

      case GamePhase.recall:
        return GameRecallPhase(
          allWords: _allWords,
          selectedWords: _selectedWords,
          onWordToggled: _onWordToggled,
          onCheckAnswers: _onCheckAnswers,
        );

      case GamePhase.result:
        return GameResultPhase(
          targetWords: _targetWords,
          selectedWords: _selectedWords,
          correctCount: _correctCount,
          wrongCount: _wrongCount,
          missedCount: _missedCount,
          onPlayAgain: _onPlayAgain,
          onHome: () => Navigator.of(context).pop(),
        );
    }
  }
}
