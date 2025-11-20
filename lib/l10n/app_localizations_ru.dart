// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Бусина принт';

  @override
  String get printButton => 'Печать';

  @override
  String get settingsButton => 'Настройки';

  @override
  String get imagePacks => 'Пакеты изображений';

  @override
  String get photoEditor => 'Редактор фото';

  @override
  String get longText => 'Длинный текст';

  @override
  String get printSettings => 'Настройки печати';

  @override
  String get quality => 'Качество';

  @override
  String get high => 'Высокое';

  @override
  String get medium => 'Среднее';

  @override
  String get low => 'Низкое';

  @override
  String get ditherAlgorithm => 'Алгоритм дизеринга';

  @override
  String get threshold => 'Порог';

  @override
  String get floydSteinberg => 'Флойд-Стейнберг';

  @override
  String get atkinson => 'Аткинсон';

  @override
  String get halftone => 'Полутон';

  @override
  String get meanThreshold => 'Средний порог';

  @override
  String get copies => 'Копии';

  @override
  String get print => 'Печать';

  @override
  String get preview => 'Предварительный просмотр';

  @override
  String get photoGallery => 'Фотогалерея';

  @override
  String get takePhoto => 'Сделать фото';

  @override
  String get editPhoto => 'Редактировать фото';

  @override
  String get addNewPack => 'Добавить новый пакет';

  @override
  String get packName => 'Название пакета';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirmDelete => 'Подтвердите удаление';

  @override
  String get deleteMessage => 'Вы уверены, что хотите удалить этот элемент?';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get textToPrint => 'Текст для печати';

  @override
  String get enterText => 'Введите ваш текст здесь...';

  @override
  String get horizontalPrinting => 'Горизонтальная печать';

  @override
  String get verticalPrinting => 'Вертикальная печать';

  @override
  String get imageRotation => 'Поворот изображения';

  @override
  String get rotate90 => 'Повернуть на 90°';

  @override
  String get rotate180 => 'Повернуть на 180°';

  @override
  String get rotate270 => 'Повернуть на 270°';

  @override
  String get energyLevel => 'Уровень энергии';

  @override
  String get light => 'Светлый';

  @override
  String get normal => 'Нормальный';

  @override
  String get dark => 'Темный';

  @override
  String get printerConnected => 'Принтер подключен';

  @override
  String get printerNotConnected => 'Принтер не подключен';

  @override
  String get connectPrinter => 'Подключить принтер';

  @override
  String get disconnectPrinter => 'Отключить принтер';

  @override
  String get connectionFailed => 'Ошибка подключения';

  @override
  String get language => 'Язык';

  @override
  String get english => 'Английский';

  @override
  String get russian => 'Русский';

  @override
  String get localeSwitch => 'Сменить язык';

  @override
  String get scan => 'Сканировать';

  @override
  String get usageGuideStep1 => '1. Подготовка и начальная настройка';

  @override
  String get usageGuideStep1Desc =>
      '• Убедитесь, что термопринтер полностью заряжен\n• Включите Bluetooth на мобильном устройстве\n• Убедитесь, что принтер включен и находится в режиме сопряжения\n• Установите приложение Busina Print из магазина приложений\n• Предоставьте необходимые разрешения при запросе';

  @override
  String get usageGuideStep2 => '2. Подключение к принтеру';

  @override
  String get usageGuideStep2Desc =>
      '• Откройте приложение Busina Print\n• Найдите значок Bluetooth в правом верхнем углу\n• Нажмите значок для поиска доступных принтеров\n• Выберите принтер из списка (часто используемые названия: GT01, GT02, GB03 и т.д.)\n• Дождитесь подтверждения подключения\n• Зеленый значок Bluetooth указывает на успешное подключение';

  @override
  String get usageGuideStep3 => '3. Печать изображений с устройства';

  @override
  String get usageGuideStep3Desc =>
      '• Перейдите на вкладку \"Печать\"\n• Нажмите кнопку \"Выбрать изображение\" (иконка камеры), чтобы выбрать из галереи\n• Выберите изображение для печати\n• Предварительный просмотр изображения в приложении\n• Выберите обычную печать или повернутую печать (для длинной печати)\n• Нажмите кнопку \"Печать\" и дождитесь завершения процесса печати\n• Примечание: Качество изображения можно настроить в параметрах перед печатью';

  @override
  String get usageGuideStep4 => '4. Печать текста';

  @override
  String get usageGuideStep4Desc =>
      '• Перейдите на главную вкладку \"Печать\"\n• Найдите раздел ввода текста\n• Введите текст в предоставленное текстовое поле\n• Используйте кнопку \"Печать текста\" для стандартной печати\n• Используйте \"Горизонтальная печать\" для длинного непрерывного текста, который растягивается по бумаге\n• Форматирование текста будет сохранено в соответствии с вашими настройками';

  @override
  String get usageGuideStep5 =>
      '5. Использование наборов изображений (организация печати)';

  @override
  String get usageGuideStep5Desc =>
      '• Перейдите на вкладку \"Наборы\"\n• Создайте новые наборы изображений или просматривайте существующие\n• Добавляйте изображения в наборы для организованной печати\n• Получайте доступ и печатайте изображения непосредственно из сохраненных наборов\n• Отлично подходит для часто печатаемых изображений или тематических коллекций';

  @override
  String get usageGuideStep6 => '6. Настройка параметров печати';

  @override
  String get usageGuideStep6Desc =>
      '• Откройте настройки с помощью значка шестеренки в правом верхнем углу\n• Регулируйте качество печати с помощью настройки уровня энергии:\n  - Высокий уровень: темная, насыщенная печать (расходует больше батареи)\n  - Низкий уровень: светлая печать (экономия батареи)\n• Выберите алгоритмы дизеринга для обработки изображений:\n  - Флойд-Стейнберг: хорош для общих изображений\n  - Аткинсон: хорош для линейного искусства и простой графики\n  - Бёркс: хорошее среднее решение\n  - Стаки: хорош для детализированных изображений\n• Установите количество копий для автоматической повторной печати\n• Регулируйте порог и настройки инверсии для оптимальных результатов';

  @override
  String get usageGuideStep7 => '7. Расширенные функции';

  @override
  String get usageGuideStep7Desc =>
      '• Интеграция с камерой: Делайте фотографии прямо в приложении для немедленной печати\n• Поворот изображения: Используйте функцию поворота для разных ориентаций печати\n• Статус принтера: Проверяйте статус подключения и информацию о принтере\n• Отключение: Безопасно отключайтесь от принтера по завершении';

  @override
  String get usageGuideStep8 => '8. Устранение распространенных проблем';

  @override
  String get usageGuideStep8Desc =>
      '• Проблемы с подключением:\n  - Убедитесь, что принтер включен и находится в зоне действия\n  - Попробуйте выключить и включить Bluetooth\n  - Перезапустите приложение\n  - Перезагрузите принтер (выключите и включите)\n• Плохое качество печати:\n  - Регулируйте уровень энергии в настройках\n  - Попробуйте разные алгоритмы дизеринга\n  - Проверьте уровень заряда принтера\n• Изображение не печатается:\n  - Проверьте статус подключения принтера\n  - Проверьте формат изображения (поддерживаются JPG, PNG)\n  - Убедитесь, что изображение не слишком большое';

  @override
  String get usageGuideTips =>
      'Расширенные советы и рекомендации по работе с принтером';

  @override
  String get usageGuideTipsDesc =>
      '• Для получения наилучших результатов используйте изображения с высоким контрастом и четкими объектами\n• Более темные уровни энергии (8-10) создают насыщенную печать, но быстрее разряжают батарею\n• Более светлые уровни (2-4) экономят батарею, но могут давать слабую печать\n• Длинная печать может занимать 2-5 минут в зависимости от сложности и размера\n• Для печати текста избегайте очень длинных строк; короткий, хорошо отформатированный текст печатается лучше\n• Храните термобумагу в прохладном, сухом месте для сохранения качества печати\n• Регулярно очищайте головку принтера для оптимальной производительности\n• Если печать слабая или с полосами, подумайте о замене рулона термобумаги\n• Для непрерывной печати текста используйте функцию горизонтальной печати\n• Протестируйте настройки печати на пробном изображении перед печатью важных документов';

  @override
  String get searching => 'Поиск...';

  @override
  String get selectPrinter => 'Выбрать принтер';

  @override
  String get noPrintersFound => 'Принтеры не найдены';

  @override
  String get printing => 'Печать...';

  @override
  String get printComplete => 'Печать завершена!';

  @override
  String get printFailed => 'Ошибка печати';

  @override
  String get back => 'Назад';

  @override
  String get next => 'Далее';

  @override
  String get previous => 'Назад';

  @override
  String get debug => 'Отладка';

  @override
  String get debugSettings => 'Настройки отладки';

  @override
  String get enableDebugging => 'Включить отладку';

  @override
  String get keepScreenOn => 'Не выключать экран';

  @override
  String get clearLog => 'Очистить лог';

  @override
  String get debugLog => 'Лог отладки';

  @override
  String get invertImage => 'Инвертировать изображение';

  @override
  String get invertImageDescription =>
      'Инвертировать черные и белые пиксели изображения';

  @override
  String get imageProcessing => 'Обработка изображения';

  @override
  String get quantity => 'Количество';

  @override
  String get rotationAngle => 'Угол поворота';

  @override
  String get paperSettings => 'Настройки бумаги';

  @override
  String get labels => 'Этикетки';

  @override
  String get autoFeed => 'Автоподача';

  @override
  String get scale => 'Масштаб';

  @override
  String get spacerSettings => 'Spacer Settings';

  @override
  String get spacerHeight => 'Spacer Height';

  @override
  String get usageGuide => 'Руководство по использованию';
}
