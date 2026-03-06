import 'package:flutter_test/flutter_test.dart';
import 'package:ibuddhism/data/resources_pt.dart';

void main() {
  group('Portuguese Resources', () {
    test('contains expected articles with markdown content', () {
      expect(resourcesPt, isNotEmpty);

      final guide =
          resourcesPt.firstWhere((r) => r.id == 'guia-de-pronuncia-e-ritmo');
      expect(guide.title, 'Gongyō: Guia de Pronúncia e Ritmo');
      expect(guide.content,
          contains('- As vogais')); // It has list item formatting

      final structure =
          resourcesPt.firstWhere((r) => r.id == 'gongyo-estrutura');
      expect(structure.content,
          contains('**Nam-myoho-renge-kyo**')); // It has bold formatting

      final flow = resourcesPt.firstWhere((r) => r.id == 'gongyo-fluxo');
      expect(
          flow.content,
          contains(
              '1. **Daimoku:**')); // It has numbered list and bold formatting
    });
  });
}
