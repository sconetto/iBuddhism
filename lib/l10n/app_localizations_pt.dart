// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'iBuddhism';

  @override
  String get navHome => 'Início';

  @override
  String get navGongyo => 'Gongyo';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navAbout => 'Sobre';

  @override
  String homeGreetingFormat(Object name, Object timeOfDay) {
    return 'Olá, $name, $timeOfDay!';
  }

  @override
  String homeGreetingNoName(Object timeOfDay) {
    return 'Olá, $timeOfDay!';
  }

  @override
  String homeGreetingLineOneWithName(Object name) {
    return 'Olá, $name 👋';
  }

  @override
  String get homeGreetingLineOneNoName => 'Olá 👋';

  @override
  String get homeTimeDay => 'bom dia';

  @override
  String get homeTimeAfternoon => 'boa tarde';

  @override
  String get homeTimeNight => 'boa noite';

  @override
  String get homeSubhead =>
      'Acesse textos de estudo e reflexão para acompanhar sua jornada.';

  @override
  String get homeCalendarTitle => 'Gongyo';

  @override
  String get homeCalendarHeader => 'Calendário de gongyo';

  @override
  String get homeCalendarProgressTitle => 'Progresso mensal';

  @override
  String get homeCalendarToday => 'Hoje';

  @override
  String get homeCalendarLegendEmpty => 'Não iniciado';

  @override
  String get homeCalendarLegendStarted => 'Iniciado';

  @override
  String get homeCalendarLegendCompleted => 'Recitado';

  @override
  String homeCalendarProgress(Object completed, Object total) {
    return '$completed/$total dias recitados';
  }

  @override
  String get homeLocalContentTitle => 'Conteúdo local';

  @override
  String get homeLocalContentBody =>
      'Todo o conteúdo está salvo no dispositivo para leitura offline.';

  @override
  String homeGreeting(Object name) {
    return 'Olá, $name';
  }

  @override
  String get themeAuto => 'Auto';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get gongyoTitle => 'Gongyo';

  @override
  String get gongyoSelectChaptersTitle =>
      'Selecione os capítulos para recitar.';

  @override
  String get gongyoSelectChaptersHint =>
      'É necessário manter pelo menos um capítulo selecionado.';

  @override
  String get gongyoHoben => 'Hoben-pon';

  @override
  String get gongyoJuryo => 'Juryo-hon';

  @override
  String get gongyoTempoLabel => 'Tempo';

  @override
  String get gongyoTempoHelp => 'Ajuste a velocidade com que o texto avança.';

  @override
  String get gongyoStart => 'Iniciar';

  @override
  String get gongyoPause => 'Pausar';

  @override
  String get gongyoResume => 'Continuar';

  @override
  String get gongyoRestart => 'Reiniciar';

  @override
  String get gongyoStop => 'Parar';

  @override
  String get gongyoExit => 'Sair';

  @override
  String get gongyoSectionDaimokuStartTitle => 'Daimoku';

  @override
  String get gongyoSectionDaimokuStartDescription =>
      'Recite Nam-myoho-renge-kyo três vezes.';

  @override
  String get gongyoSectionHobenTitle => 'Hoben-pon (Cap. 2)';

  @override
  String get gongyoSectionHobenDescription => 'Até o último “ma ku kyo to”.';

  @override
  String get gongyoSectionJuryoTitle => 'Juryo-hon (Cap. 16)';

  @override
  String get gongyoSectionJuryoDescription =>
      'O capítulo da “Duração da Vida do Tathagata”.';

  @override
  String get gongyoSectionDaimokuEndTitle => 'Daimoku (Encerramento)';

  @override
  String get gongyoSectionDaimokuEndDescription =>
      'Continue a recitar Nam-myoho-renge-kyo com foco no Gohonzon.';

  @override
  String get libraryTitle => 'Biblioteca';

  @override
  String resourceSource(Object source) {
    return 'Fonte: $source';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsLanguageDescription => 'Escolha o idioma do app.';

  @override
  String get settingsLanguagePortuguese => 'Português 🇧🇷';

  @override
  String get settingsLanguageEnglish => 'Inglês 🇺🇸';

  @override
  String get settingsAboutTitle => 'Sobre';

  @override
  String get settingsAboutBody =>
      'iBuddhism é um companheiro minimalista para Gongyo e estudo.';

  @override
  String get settingsAction => 'Ajustes';

  @override
  String get profileAction => 'Perfil';

  @override
  String get settingsProfileTitle => 'Perfil';

  @override
  String get settingsProfileNameLabel => 'Seu nome';

  @override
  String get settingsProfileNameHint => 'Digite seu nome';

  @override
  String get settingsProfileNameDescription =>
      'Este nome fica salvo localmente no dispositivo.';

  @override
  String get settingsProfileBioLabel => 'Bio';

  @override
  String get settingsProfileBioHint => 'Compartilhe uma nota curta';

  @override
  String get settingsProfileAvatarTitle => 'Cor do perfil';

  @override
  String get settingsProfileAvatarCamera => 'Câmera';

  @override
  String get settingsProfileAvatarGallery => 'Galeria';

  @override
  String get settingsProfileAvatarRemove => 'Remover foto do perfil';

  @override
  String get settingsProfileDobLabel => 'Data de nascimento';

  @override
  String get settingsProfileDobPick => 'Selecionar data';

  @override
  String settingsProfileAge(Object age) {
    return '$age anos';
  }

  @override
  String get settingsProfileWeeklyGoalLabel => 'Meta semanal';

  @override
  String get settingsGongyoGoalTitle => 'Meta de gongyo';

  @override
  String settingsProfileWeeklyGoalValue(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vezes/semana',
      one: '$count vez/semana',
    );
    return '$_temp0';
  }

  @override
  String get aboutTitle => 'Sobre';

  @override
  String get aboutHeadline => 'iBuddhism';

  @override
  String get aboutBody =>
      'iBuddhism é um companheiro minimalista para Gongyo e estudo, criado para apoiar a prática diária com clareza e presença.';

  @override
  String get aboutAuthorTitle => 'Autor';

  @override
  String get aboutAuthorBody =>
      'Criado por João Pedro Sconetto e Mariana de Souza Mendes.\nFeito com ♥️ e ☕.';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'iBuddhism';

  @override
  String get navHome => 'Início';

  @override
  String get navGongyo => 'Gongyo';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navAbout => 'Sobre';

  @override
  String homeGreetingFormat(Object name, Object timeOfDay) {
    return 'Olá, $name, $timeOfDay!';
  }

  @override
  String homeGreetingNoName(Object timeOfDay) {
    return 'Olá, $timeOfDay!';
  }

  @override
  String homeGreetingLineOneWithName(Object name) {
    return 'Olá, $name 👋';
  }

  @override
  String get homeGreetingLineOneNoName => 'Olá 👋';

  @override
  String get homeTimeDay => 'bom dia';

  @override
  String get homeTimeAfternoon => 'boa tarde';

  @override
  String get homeTimeNight => 'boa noite';

  @override
  String get homeSubhead =>
      'Acesse textos de estudo e reflexão para acompanhar sua jornada.';

  @override
  String get homeCalendarTitle => 'Gongyo';

  @override
  String get homeCalendarHeader => 'Calendário de gongyo';

  @override
  String get homeCalendarProgressTitle => 'Progresso mensal';

  @override
  String get homeCalendarToday => 'Hoje';

  @override
  String get homeCalendarLegendEmpty => 'Não iniciado';

  @override
  String get homeCalendarLegendStarted => 'Iniciado';

  @override
  String get homeCalendarLegendCompleted => 'Recitado';

  @override
  String homeCalendarProgress(Object completed, Object total) {
    return '$completed/$total dias recitados';
  }

  @override
  String get homeLocalContentTitle => 'Conteúdo local';

  @override
  String get homeLocalContentBody =>
      'Todo o conteúdo está salvo no dispositivo para leitura offline.';

  @override
  String homeGreeting(Object name) {
    return 'Olá, $name';
  }

  @override
  String get themeAuto => 'Auto';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get gongyoTitle => 'Gongyo';

  @override
  String get gongyoSelectChaptersTitle =>
      'Selecione os capítulos para recitar.';

  @override
  String get gongyoSelectChaptersHint =>
      'É necessário manter pelo menos um capítulo selecionado.';

  @override
  String get gongyoHoben => 'Hoben-pon';

  @override
  String get gongyoJuryo => 'Juryo-hon';

  @override
  String get gongyoTempoLabel => 'Tempo';

  @override
  String get gongyoTempoHelp => 'Ajuste a velocidade com que o texto avança.';

  @override
  String get gongyoStart => 'Iniciar';

  @override
  String get gongyoPause => 'Pausar';

  @override
  String get gongyoResume => 'Continuar';

  @override
  String get gongyoRestart => 'Reiniciar';

  @override
  String get gongyoStop => 'Parar';

  @override
  String get gongyoExit => 'Sair';

  @override
  String get gongyoSectionDaimokuStartTitle => 'Daimoku';

  @override
  String get gongyoSectionDaimokuStartDescription =>
      'Recite Nam-myoho-renge-kyo três vezes.';

  @override
  String get gongyoSectionHobenTitle => 'Hoben-pon (Cap. 2)';

  @override
  String get gongyoSectionHobenDescription => 'Até o último “ma ku kyo to”.';

  @override
  String get gongyoSectionJuryoTitle => 'Juryo-hon (Cap. 16)';

  @override
  String get gongyoSectionJuryoDescription =>
      'O capítulo da “Duração da Vida do Tathagata”.';

  @override
  String get gongyoSectionDaimokuEndTitle => 'Daimoku (Encerramento)';

  @override
  String get gongyoSectionDaimokuEndDescription =>
      'Continue a recitar Nam-myoho-renge-kyo com foco no Gohonzon.';

  @override
  String get libraryTitle => 'Biblioteca';

  @override
  String resourceSource(Object source) {
    return 'Fonte: $source';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsLanguageDescription => 'Escolha o idioma do app.';

  @override
  String get settingsLanguagePortuguese => 'Português 🇧🇷';

  @override
  String get settingsLanguageEnglish => 'Inglês 🇺🇸';

  @override
  String get settingsAboutTitle => 'Sobre';

  @override
  String get settingsAboutBody =>
      'iBuddhism é um companheiro minimalista para Gongyo e estudo.';

  @override
  String get settingsAction => 'Ajustes';

  @override
  String get profileAction => 'Perfil';

  @override
  String get settingsProfileTitle => 'Perfil';

  @override
  String get settingsProfileNameLabel => 'Seu nome';

  @override
  String get settingsProfileNameHint => 'Digite seu nome';

  @override
  String get settingsProfileNameDescription =>
      'Este nome fica salvo localmente no dispositivo.';

  @override
  String get settingsProfileBioLabel => 'Bio';

  @override
  String get settingsProfileBioHint => 'Compartilhe uma nota curta';

  @override
  String get settingsProfileAvatarTitle => 'Cor do perfil';

  @override
  String get settingsProfileAvatarCamera => 'Câmera';

  @override
  String get settingsProfileAvatarGallery => 'Galeria';

  @override
  String get settingsProfileAvatarRemove => 'Remover foto do perfil';

  @override
  String get settingsProfileDobLabel => 'Data de nascimento';

  @override
  String get settingsProfileDobPick => 'Selecionar data';

  @override
  String settingsProfileAge(Object age) {
    return '$age anos';
  }

  @override
  String get settingsProfileWeeklyGoalLabel => 'Meta semanal';

  @override
  String get settingsGongyoGoalTitle => 'Meta de gongyo';

  @override
  String settingsProfileWeeklyGoalValue(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vezes/semana',
      one: '$count vez/semana',
    );
    return '$_temp0';
  }

  @override
  String get aboutTitle => 'Sobre';

  @override
  String get aboutHeadline => 'iBuddhism';

  @override
  String get aboutBody =>
      'iBuddhism é um companheiro minimalista para Gongyo e estudo, criado para apoiar a prática diária com clareza e presença.';

  @override
  String get aboutAuthorTitle => 'Autor';

  @override
  String get aboutAuthorBody =>
      'Criado por João Pedro Sconetto e Mariana de Souza Mendes.\nFeito com ♥️ e ☕.';
}
