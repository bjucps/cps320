import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'dart:math';
import 'dart:async';

void showConfetti(BuildContext context, {int count = 100}) {
  Confetti.launch(
    context,
    options: ConfettiOptions(particleCount: count, spread: 70, y: 0.6),
  );
}

void showConfettiEmoji(BuildContext context, {int count = 100}) {
  Confetti.launch(
    context,
    options: ConfettiOptions(particleCount: count, spread: 70, y: 0.6),
    particleBuilder: (index) => Emoji(emoji: '🎵'),
  );
}

void showConfettiMix(BuildContext context) {
  showConfetti(context, count: 75);
  showConfettiEmoji(context, count: 25);
}

void showConfettiColor(BuildContext context, Color color) {
  Confetti.launch(
    context,
    options: ConfettiOptions(
      particleCount: 100,
      spread: 70,
      y: 0.6,
      colors: [color],
    ),
  );
}

void showFireworksConfetti(BuildContext context) {
  int total = 10;
  int progress = 0;

  Timer.periodic(const Duration(milliseconds: 250), (timer) {
    progress++;

    if (progress >= total) {
      timer.cancel();
      return;
    }

    int count = ((1 - progress / total) * 50).toInt();

    Confetti.launch(
      context,
      options: ConfettiOptions(
        particleCount: count,
        startVelocity: 10,
        spread: 360,
        ticks: 60,
        x: randomInRange(0.1, 0.3),
        y: Random().nextDouble() - 0.2,
      ),
    );
    Confetti.launch(
      context,
      options: ConfettiOptions(
        particleCount: count,
        startVelocity: 10,
        spread: 360,
        ticks: 60,
        x: randomInRange(0.7, 0.9),
        y: Random().nextDouble() - 0.2,
      ),
    );
  });
}

double randomInRange(double min, double max) {
  return min + Random().nextDouble() * (max - min);
}
