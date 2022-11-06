unit Languages;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils, System.IniFiles, System.DateUtils,
  System.Generics.Collections, Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls,
  synautil, ConstData, Functions;

  function GetLangList: Integer;
  function Load(Key, Default: string): string;
  function TransStr(const StrID: string): string;
  procedure LoadLns(Key, Default: string);
  procedure LoadStr(Key, Default: string);
  procedure Translate(Section: string);
  procedure TranslateArray(var HeaderArray: array of string; Header: string);

var
  DetailsHeader: array [0..5] of string;
  FilterHeader: array [0..7] of string;
  HsHeader: array [0..3] of string;
  HsPortsHeader: array [0..2] of string;
  RoutersHeader: array [0..8] of string;
  CircuitsHeader: array [0..0] of string;
  StreamsHeader: array [0..0] of string;
  StreamsInfoHeader: array [0..2] of string;
  TransportsHeader: array [0..2] of string;
  Prefixes: array[0..6] of string;
  LangStr: TDictionary<string, string>;
  LangIniFile: TMemIniFile;
  CurrentTranslate: string;
  CurrentLanguage: Word;

implementation

uses
  Main;

procedure TranslateArray(var HeaderArray: array of string; Header: string);
var
  i: Integer;
  ls: TStringList;
begin
  ls := TStringList.Create;
  try
    ParseParametersEx(Header, ',', ls);
    for i := 0 to Length(HeaderArray) - 1 do
      if i < ls.Count then
        HeaderArray[i] := ls[i];
  finally
    ls.Free;
  end;
end;

function GetLangList: Integer;
var
  ini: TMemIniFile;
  ls, rs: TStringList;
  i, LangID, English: Integer;
  SystemLanguage: Word;
begin
  Result := 0;
  English := 0;
  SystemLanguage := GetSystemDefaultLangID;
  ls := TStringList.Create;
  try
    if FileExists(LangFile) then
    begin
      ini := TMemIniFile.Create(LangFile, TEncoding.UTF8);
      rs := TStringList.Create;
      try
        ini.ReadSections(rs);
        for i := 0 to rs.Count - 1 do
        begin
          if rs[i] = 'DefaultCountries' then
            continue;
          LangID := ini.ReadInteger(rs[i], 'Locale', 0);
          ls.AddObject(rs[i], TObject(Integer(LangID)));
          if LangID = SystemLanguage then
            Result := LangID;
          if LangID = 1033 then
            English := 1033;
        end;
      finally
        ini.Free;
        rs.Free;
      end;

      if Result = 0 then
      begin
        case SystemLanguage of
          1049: Result := 1049;
          1058: Result := 1049;
          1059: Result := 1049;
          else
          begin
            if English > 0 then
              Result := English;
          end;
        end;
      end;

    end;
    ls.AddObject('Русский', TObject(Integer(1049)));
    Tcp.cbxLanguage.Items := ls;
  finally
    ls.Free;
  end;
end;

function TransStr(const StrID: string): string;
begin
  LangStr.TryGetValue(StrID, Result);
end;

function Load(Key, Default: string): string;
begin
  Result := LangIniFile.ReadString(CurrentTranslate, Key, Default)
end;

procedure LoadList(ls: TCombobox; Key, Default: string);
var
  Index: Integer;
begin
  Index := ls.ItemIndex;
  ls.Items.DelimitedText := LangIniFile.ReadString(CurrentTranslate, Key, Default);
  ls.ItemIndex := Index;
end;

procedure LoadStr(Key, Default: string);
begin
  LangStr.AddOrSetValue(Key, LangIniFile.ReadString(CurrentTranslate, Key, Default));
end;

procedure LoadLns(Key, Default: string);
begin
  LangStr.AddOrSetValue(Key, StringReplace(LangIniFile.ReadString(CurrentTranslate, Key, Default), '\n', BR, [rfReplaceAll]));
end;

procedure Translate(Section: string);
var
  i: Integer;
begin
  CurrentTranslate := Section;
  if Assigned(LangStr) then
    LangStr.Clear
  else
    LangStr := TDictionary<String, String>.Create;

  LangIniFile := TMemIniFile.Create(LangFile, TEncoding.UTF8);
  try
    LoadStr('Locale', '1049');
    LoadStr('100', 'Старт');
    LoadStr('101', 'Запуск...');
    LoadStr('102', 'Стоп');
    LoadLns('103', 'Сменить\nцепочку');
    LoadStr('104', 'По умолчанию');
    LoadStr('105', 'Панель управления Tor');
    LoadLns('106', '%s\nПрофиль: %s');
    LoadStr('107', 'Настройки');
    LoadStr('108', 'Журнал');
    LoadStr('109', 'Не получен');
    LoadStr('110', 'Не определена');
    LoadStr('111', 'Получение...');
    LoadStr('112', 'Определение...');
    LoadStr('113', 'IP адрес');
    LoadStr('114', 'Страна');
    LoadStr('122', 'Скрытый сервис');
    LoadStr('130', 'Пароль');
    LoadStr('135', 'сек.');
    LoadStr('146', 'Преобразование в хэши включено');
    LoadStr('151', 'Тип');
    LoadStr('153', 'Порт');
    LoadStr('159', 'Необязательно');
    LoadStr('160', 'Прокручивать вверх при сортировке');
    LoadLns('161', 'Текущая конфигурация авангардов для скрытых сервисов требует как минимум %d избранных входных узлов (Найдено: %d). \n\nИсправить проблему и продолжить сохранение настроек?');
    LoadStr('164', 'Эта операция требует перезапуска Tor');
    LoadStr('175', 'Максимум');
    LoadStr('180', 'c');
    LoadStr('181', 'Проверка переадресации портов');
    LoadStr('197', 'мин.');
    LoadStr('203', 'Всего');
    LoadStr('204', 'Внимание! Отключение кэша каталога ускорит работу сервера, но ваш сервер никогда не станет сторожевым узлом. Хотите продолжить?');
    LoadStr('206', 'Обычный');
    LoadLns('208', '\n  Щёлкните здесь для добавления адресов\n\n  Примеры:\n\n       Ip: 8.8.8.8\n     Сайт: metrics.torproject.org\n    Домен:.torproject.org\n      Все:.');
    LoadLns('209', '\n  Щёлкните здесь для добавления узлов\n\n  Примеры:\n\n       Ip: 8.8.8.8\n     CIDR: 8.8.8.8/24\n   Страна: RU,DE,US,..\n      Хэш: ABCD1234CDEF567..');
    LoadLns('210', '\n  Щёлкните здесь для добавления мостов\n\n  Примеры:\n\n         8.8.8.8:443\n         8.8.8.8:443 ABCD1234CDEF567..\n   obfs4 8.8.8.8:443 ABCD1234CDEF567.. cert=.. iat-mode=..\n\n Примечание: мосты переопределяют настройки входных узлов');
    LoadStr('212', 'Загрузка');
    LoadStr('213', 'Отправка');
    LoadStr('214', 'Получено');
    LoadStr('215', 'Отправлено');
    LoadStr('221', 'Дата создания');
    LoadStr('226', 'Выключен');
    LoadStr('230', 'Название,Версия,Точек входа,Соединений');
    LoadStr('231', 'Интерфейс,Порт,Виртуальный');
    LoadStr('232', 'Ник,IP адрес,,Страна,Вес,Пинг');
    LoadStr('233', 'ID,,Страна,Всего,Вход,Выход,Живые,∑ пинг');
    LoadStr('234', 'Б,КБ,МБ,ГБ,ТБ,ПБ,ЭБ');
    LoadStr('235', 'Информация');
    LoadStr('236', 'Ошибка при разборе конфигурационного файла torrc, подробности смотрите в журнале');
    LoadStr('237', 'Подключение к сети Tor остановлено, неверно указан пароль для управляющего порта!');
    LoadLns('238', 'Исполняемый файл Tor не запускается. Возможно он:\n\n - повреждён или не является приложением Windows\n - является 64-битным приложением, в то время как у вас 32-битная операционная система.');
    LoadStr('239', 'Исполняемый файл Tor не найден. Скачайте Tor Windows Expert Bundle и распакуйте в каталог с программой. Перейти на страницу загрузки прямо сейчас?');
    LoadStr('240', 'Подключение к сети Tor...');
    LoadStr('241', 'Вы отключились от сети Tor');
    LoadStr('242', 'Устройств с поддержкой переадресации портов не найдено!');
    LoadStr('243', 'Результат');
    LoadStr('244', 'Источник,Назначение,Цель');
    LoadStr('245', 'Успешно');
    LoadStr('246', 'Предупреждение');
    LoadStr('247', 'Ошибка');
    LoadStr('248', 'Название не может быть пустым!');
    LoadStr('249', 'Это название уже используется другим сервисом!');
    LoadStr('250', 'Список портов');
    LoadStr('251', 'Вы должны добавить хотя бы один порт!');
    LoadStr('252', 'Такая комбинация интерфейса и портов уже существует!');
    LoadStr('253', 'Пароль для управляющего порта изменён');
    LoadStr('254', 'Ошибка при загрузке шаблона: параметры заданы неверно!');
    LoadStr('255', 'Нельзя использовать разделительный символ " %s "');
    LoadStr('256', 'Сохранение шаблона');
    LoadStr('257', 'Введите название шаблона');
    LoadStr('258', 'Цепочка изменена');
    LoadLns('259', 'Запуск приостановлен, порты указанные в настройках программы уже используются!\n\nЗанятые порты: %s \n\nИзменить порты на случайные и продолжить запуск?');
    LoadStr('260', 'Не определён');
    LoadLns('261', 'Использовать мосты, прокси и разрешённые порты в режиме сервера нельзя!\n\nВыключить эти опции и продолжить сохранение настроек?');
    LoadStr('262', 'Подтверждение');
    LoadStr('263', 'Вы действительно хотите удалить %s"%s"?');
    LoadStr('264', 'Все шаблоны');
    LoadStr('265', 'Создание ярлыка');
    LoadStr('266', 'Введите название профиля');
    LoadStr('267', 'Все сервисы');
    LoadLns('268', 'Вы действительно хотите добавить:\n\n%s\n\nв список "%s узлы"?%s');
    LoadLns('269', 'Используйте только буквы латинского алфавита и цифры');
    LoadStr('270', 'и');
    LoadStr('271', 'Конфигурационный файл Tor');
    LoadStr('274', 'Копировать');
    LoadStr('275', 'Вставить');
    LoadStr('276', 'Вырезать');
    LoadStr('277', 'Выделить всё');
    LoadStr('278', 'Очистить');
    LoadStr('279', 'Добавить');
    LoadStr('280', 'Удалить');
    LoadStr('281', 'Информация по ретранслятору');
    LoadStr('282', 'Статус');
    LoadStr('284', 'Обновить');
    LoadStr('285', 'Изменить список узлов');
    LoadStr('287', 'Запрещённые');
    LoadStr('288', 'Входныe');
    LoadStr('289', 'Средние');
    LoadStr('290', 'Выходные');
    LoadStr('320', 'Ник,IP адрес,,Страна,Вес,Порт,Версия,Пинг,Флаги');
    LoadStr('321', 'Показано: %d из %d');
    LoadLns('322', '\n  Список хэшей, определяющих ваше семейство\n\n  Пример:\n\n        ABCD1234CDEF567..');
    LoadStr('323', 'Роутеры');
    LoadStr('324', 'Неправильные настройки');
    LoadStr('326', 'Протокол скрытых сервисов второй версии устарел, его поддержка была прекращена в версии 0.4.6.1 и выше. Вы действительно хотите использовать эту версию протокола?');
    LoadStr('327', 'Цепочки');
    LoadStr('328', 'Уменьшить окно');
    LoadStr('329', 'Назначение');
    LoadStr('330', 'Целевой адрес');
    LoadStr('331', 'Запрос каталога');
    LoadStr('332', 'Внутренний трафик');
    LoadStr('333', 'Выходной трафик');
    LoadStr('334', 'Клиент: Запрос каталога');
    LoadStr('335', 'Клиент: Точка входа');
    LoadStr('336', 'Клиент: Место встречи');
    LoadStr('337', 'Сервис: Запрос каталога');
    LoadStr('338', 'Сервис: Точка входа');
    LoadStr('339', 'Сервис: Место встречи');
    LoadStr('340', 'Авангард скрытого сервиса');
    LoadStr('341', 'Проверка закрытия цепочки');
    LoadStr('342', 'Проверка доступности');
    LoadStr('343', 'Маскировка времени');
    LoadStr('344', 'Измерение ожидания');
    LoadStr('345', 'Другое назначение');
    LoadStr('346', 'Внимание! Частая смена сторожевых узлов может помочь злоумышленникам обнаружить вас. Используйте только в случае крайней необходимости. %sХотите продолжить?');
    LoadStr('347', '(Все страны)');
    LoadStr('348', '(Выбранные в фильтре)');
    LoadStr('349', 'Цепочек: %d из %d');
    LoadStr('350', 'Соединений');
    LoadStr('351', 'Привязать к выходному узлу');
    LoadStr('352', 'Отвязать от выходного узла');
    LoadStr('353', 'Глобальный домен');
    LoadStr('354', 'Настройки программы были изменены! Хотите применить изменения?');
    LoadStr('355', 'О программе');
    LoadLns('356', '%s, версия: %s\n\n%s\n\n(Windows GUI-клиент для Tor Expert Bundle)\n\n%s\n\nХотите посетить страницу программы на GitHub?');
    LoadStr('357', 'Эта программа является свободным программным обеспечением и распространяется по лицензии MIT');
    LoadLns('358', 'Узлы, отсутствующие в консенсусе, будут удалены из пользовательских списков.\n\nИгнорировать список исключенных узлов при сканировании?');
    LoadStr('359', 'Удалить из списков');
    LoadStr('360', 'Автоподбор роутеров');
    LoadLns('361', 'Вы действительно хотите удалить:\n\n%s\n\nиз всех списков узлов?%s');
    LoadLns('362', 'Вы действительно хотите удалить:\n\n%s\n\nиз списка "%s узлы"?%s');
    LoadStr('363', 'Шаблон "%s" успешно сохранён');
    LoadStr('364', 'Шаблон "%s" успешно загружен');
    LoadStr('365', 'Шаблон "%s" успешно удалён');
    LoadStr('366', 'шаблон');
    LoadStr('367', 'сервис');
    LoadStr('368', 'Выбрать все');
    LoadStr('369', 'Снять все');
    LoadStr('370', 'Запрос каталога');
    LoadStr('371', 'Загрузка каталога');
    LoadStr('372', 'Тест порта каталога');
    LoadStr('373', 'DNS-запрос');
    LoadStr('374', 'Обычный трафик');
    LoadStr('375', 'Другая цель');
    LoadStr('376', 'Внутренний сокет');
    LoadStr('377', 'Для нормальной работы программы требуется Tor Windows Expert Bundle версии 0.4.0.5 и выше.');
    LoadStr('378', 'Не удается найти "%s"');
    LoadStr('379', 'мс');
    LoadStr('380', 'Автоматический режим');
    LoadStr('381', 'Ручной режим');
    LoadStr('382', 'Измерение пинга');
    LoadStr('383', 'Определение живых узлов');
    LoadStr('384', 'Мост (Входной узел)');
    LoadStr('385', 'Корневой каталог');
    LoadStr('386', 'Живой (отвечает на соединения)');
    LoadStr('387', 'Принимает IPv6-соединения');
    LoadStr('388', 'Каталог скрытых сервисов');
    LoadStr('389', 'Зеркало каталога (порт: %d)');
    LoadStr('390', 'Не рекомендуемая версия');
    LoadStr('391', 'Плохой выходной узел');
    LoadStr('392', 'Неизвестный флаг');
    LoadStr('393', 'Транспорты,Обработчик,Тип');
    LoadStr('394', 'Список транспортов не может содержать пустые данные');
    LoadStr('395', 'Не найден файл обработчика, скопируйте его в каталог транспортов и повторите');
    LoadStr('396', 'Определение живых мостов');
    LoadStr('397', 'Последняя поддерживаемая версия для вашей операционной системы: 0.4.4.6');
    LoadStr('398', 'Цифры в начале слова запрещены');
    LoadStr('399', 'Транспорт с таким названием и типом уже существует');
    LoadLns('400', 'Идёт сканирование мостов...\n\nДождитесь окончания и повторите попытку.');
    LoadStr('401', 'Нет соединения');
    LoadStr('402', 'Начало учёта: %s');
    LoadStr('404', 'Остановка сканирования..');
    LoadLns('405', 'Вы действительно хотите: "%s"\n\nВыбранное действие нельзя будет отменить!');
    LoadStr('406', 'Удалить все');
    LoadStr('423', 'Найти...');
    LoadStr('444', 'Сетевой сканер');
    LoadStr('459', 'мсек.');
    LoadStr('470', 'шт.');
    LoadStr('477', 'ч.');
    LoadStr('515', 'Выделять все ячейки в строке');
    LoadStr('521', 'Выбранные страны');
    LoadStr('522', 'Избранные узлы');
    LoadStr('523', 'Запрещённые узлы');
    LoadStr('524', 'Уничтожить');
    LoadStr('525', 'Сортировка');
    LoadStr('526', 'Фильтры');
    LoadStr('528', 'Соединения');
    LoadStr('530', 'Назначение');
    LoadStr('547', 'Тип узла');

    TranslateArray(HsHeader, TransStr('230'));
    TranslateArray(HsPortsHeader, TransStr('231'));
    TranslateArray(DetailsHeader, TransStr('232'));
    TranslateArray(FilterHeader, TransStr('233'));
    TranslateArray(RoutersHeader, TransStr('320'));
    TranslateArray(CircuitsHeader, TransStr('329'));
    TranslateArray(StreamsHeader, TransStr('330'));
    TranslateArray(StreamsInfoHeader, TransStr('244'));
    TranslateArray(TransportsHeader, TransStr('393'));

    for i := 0 to Length(Prefixes) - 1 do
      ConstDic.Remove(Prefixes[i]);
    TranslateArray(Prefixes, TransStr('234'));
    for i := 0 to Length(Prefixes) - 1 do
      ConstDic.AddOrSetValue(Prefixes[i], i);

    if UserProfile = 'User' then
      Tcp.lbUserDir.Caption := TransStr('104')
    else
      Tcp.lbUserDir.Caption := UserProfile;
    Tcp.tiTray.Hint := Format(TransStr('106'), [TransStr('105'), Tcp.lbUserDir.Caption]);
    Tcp.Caption := TransStr('105');
    Application.Title := TransStr('105');
    if ConnectState = 0 then
    begin
      Tcp.btnSwitchTor.Caption := TransStr('100');
      Tcp.miSwitchTor.Caption := TransStr('100');
      Tcp.lbExitIp.Caption := TransStr('109');
      Tcp.lbExitCountry.Caption := TransStr('110');
    end;
    if ConnectState = 2 then
    begin
      Tcp.btnSwitchTor.Caption := TransStr('102');
      Tcp.miSwitchTor.Caption := TransStr('102');
    end;
    Tcp.btnChangeCircuit.Caption := TransStr('103');
    Tcp.sbShowOptions.Caption := TransStr('107');
    Tcp.sbShowLog.Caption := TransStr('108');
    Tcp.sbShowStatus.Caption := TransStr('282');
    Tcp.sbShowCircuits.Caption := TransStr('327');
    Tcp.sbShowRouters.Caption := TransStr('323');
    Tcp.sbDecreaseForm.Hint := TransStr('328');

    Tcp.lbExitIpCaption.Caption := TransStr('113') + ':';
    Tcp.lbExitCountryCaption.Caption := TransStr('114') + ':';
    Tcp.btnApplyOptions.Caption := Load('115', 'Применить');
    Tcp.btnCancelOptions.Caption := Load('116', 'Отмена');

    Tcp.tsMain.Caption := Load('118', 'Общие');
    Tcp.tsNetwork.Caption := Load('119', 'Сеть');
    Tcp.tsFilter.Caption := Load('120', 'Фильтр');
    Tcp.tsServer.Caption := Load('121', 'Сервер');
    Tcp.tsHs.Caption := TransStr('122');
    Tcp.tsOther.Caption := Load('123', 'Разное');
    Tcp.tsLists.Caption := Load('546', 'Списки');

    Tcp.gbOptions.Caption := Load('410', 'Основные');
    Tcp.lbMaxCircuitDirtiness.Caption := Load('124', 'Менять цепочку существующую более чем');
    Tcp.lbNewCircuitPeriod.Caption := Load('125', 'Интервал между попытками построить цепочку');
    Tcp.lbCircuitBuildTimeout.Caption := Load('126', 'Макс. время на построение цепочки');
    Tcp.lbMaxClientCircuitsPending.Caption := Load('317', 'Количество ожидающих цепочек клиента');
    Tcp.cbLearnCircuitBuildTimeout.Caption := Load('136', 'Автоматически выбирать время на построение цепочки');
    Tcp.cbEnforceDistinctSubnets.Caption := Load('137', 'Не строить цепочки из узлов одной подсети');
    Tcp.cbAvoidDiskWrites.Caption := Load('138', 'Выполнять меньше операций с диском');
    Tcp.cbStrictNodes.Caption := Load('318', 'Разрешить запрещённые узлы для внутренних цепочек');
    Tcp.cbUseOpenDNS.Caption := Load('407', 'Определять внешний адрес сервера через OpenDNS');
    Tcp.cbUseOpenDNSOnlyWhenUnknown.Caption := Load('408', 'Только если TOR не может определить его сам');
    Tcp.cbUseNetworkCache.Caption := Load('409', 'Кэшировать IP-cc-запросы и результаты сетевого сканера');
    Tcp.lbTheme.Caption := Load('413', 'Тема');
    Tcp.lbLanguage.Caption := Load('132', 'Язык');
    Tcp.lbSeconds1.Caption := TransStr('135');
    Tcp.lbSeconds2.Caption := TransStr('135');
    Tcp.lbSeconds3.Caption := TransStr('135');

    Tcp.gbControlAuth.Caption := Load('412', 'Управление');
    Tcp.lbControlPort.Caption := Load('127', 'Порт');
    Tcp.lbAuthMetod.Caption := Load('128', 'Аутентификация');
    LoadList(Tcp.cbxAuthMetod, '129', '"Cookie-файл","Пароль"');
    Tcp.lbControlPassword.Caption := TransStr('130');
    Tcp.imGeneratePassword.Hint := Load('131', 'Сгенерировать случайный пароль');

    Tcp.gbInterface.Caption := Load('411', 'Интерфейс');
    Tcp.cbConnectOnStartup.Caption := Load('139', 'Подключаться при запуске программы');
    Tcp.cbRestartOnControlFail.Caption := Load('140', 'Перезапуск при обрыве связи с клиентом');
    Tcp.cbMinimizeOnStartup.Caption := Load('141', 'Сворачивать в трей при запуске');
    Tcp.cbMinimizeOnClose.Caption := Load('142', 'Сворачивать в трей при закрытии');
    Tcp.cbShowBalloonHint.Caption := Load('143', 'Показывать всплывающие сообщения');
    Tcp.cbShowBalloonOnlyWhenHide.Caption := Load('144', 'Только когда программа свёрнута');
    Tcp.cbStayOnTop.Caption := Load('145', 'Оставаться поверх всех окон');
    Tcp.cbNoDesktopBorders.Caption := Load('414', 'Разрешить окну выходить за границы экрана');
    Tcp.cbNoDesktopBordersOnlyEnlarged.Caption := Load('415', 'Только при увеличенном окне программы');
    Tcp.cbRememberEnlargedPosition.Caption := Load('416', 'Запоминать позицию увеличенного окна');
    Tcp.cbHideIPv6Addreses.Caption := Load('417', 'Скрывать IPv6-адреса в списках интерфейсов');
    Tcp.cbClearPreviousSearchQuery.Caption := Load('418', 'Очищать предыдущий поисковый запрос в списках');

    Tcp.gbProfile.Caption := Load('134', 'Профиль');
    Tcp.btnCreateProfile.Caption := Load('117', 'Создать..');
    Tcp.lbCreateProfile.Caption := Load('133', 'Ярлык программы с новым профилем на рабочем столе');

    Tcp.cbUseReachableAddresses.Caption := Load('147', 'Мой сетевой экран разрешает подключаться только к этим портам');
    Tcp.lbReachableAddresses.Caption := Load('148', 'Список портов');
    Tcp.cbEnableSocks.Caption := Load('149', 'Включить встроенный прокси');
    Tcp.cbUseProxy.Caption := Load('150', 'Я использую прокси для подключения к Интернету');
    Tcp.lbProxyType.Caption := TransStr('151');
    Tcp.lbProxyAddress.Caption := Load('152', 'Адрес');
    Tcp.lbProxyPort.Caption := TransStr('153');
    Tcp.lbProxyUser.Caption := Load('154', 'Логин');
    Tcp.lbProxyPassword.Caption := TransStr('130');
    Tcp.cbUseBridges.Caption := Load('155', 'Использовать мосты');
    Tcp.edControlPassword.TextHint := Load('156', 'Введите пароль');
    Tcp.edReachableAddresses.TextHint := Load('157', 'Значения, разделённые запятыми');
    Tcp.edProxyAddress.TextHint := Load('158', 'IP-адрес или имя узла');
    Tcp.edProxyUser.TextHint := TransStr('159');
    Tcp.edProxyPassword.TextHint := TransStr('159');
    Tcp.meBridges.TextHint.Text := TransStr('210');
    Tcp.lbBridgesType.Caption := TransStr('151');
    Tcp.lbBridgesList.Caption := Load('419', 'Список мостов');
    Tcp.cbUsePreferredBridge.Caption := Load('420', 'Задать предпочитаемый мост вручную');
    Tcp.lbPreferredBridge.Caption := Load('421', 'Мост');
    Tcp.edPreferredBridge.TextHint  := Load('422', 'Эта настройка переопределяет выбранный список  мостов');
    Tcp.btnFindPreferredBridge.Caption := TransStr('423');
    LoadList(Tcp.cbxBridgesType, '424', '"Встроенные","Пользовательские"');

    Tcp.lbFilterMode.Caption := Load('162', 'Режим');
    Tcp.lbFilterEntry.Caption := TransStr('288') + ': ' + IntToStr(Tcp.lbFilterEntry.Tag);
    Tcp.lbFilterMiddle.Caption := TransStr('289') + ': ' + IntToStr(Tcp.lbFilterMiddle.Tag);
    Tcp.lbFilterExit.Caption := TransStr('290') + ': ' + IntToStr(Tcp.lbFilterExit.Tag);
    Tcp.lbFilterExclude.Caption := TransStr('287') + ': ' + IntToStr(Tcp.lbFilterExclude.Tag);
    LoadList(Tcp.cbxFilterMode, '165', '"Отключено", "Выбранные страны", "Избранные узлы"');

    Tcp.lbServerMode.Caption := Load('166', 'Режим работы');
    Tcp.lbNickname.Caption := Load('167', 'Ник');
    Tcp.lbContactInfo.Caption := Load('168', 'Контакты');
    Tcp.lbBridgeType.Caption := Load('169', 'Тип моста');
    Tcp.lbExitPolicy.Caption := Load('170', 'Политика выхода');
    Tcp.lbORPort.Caption := Load('171', 'Сервер');
    Tcp.lbDirPort.Caption := Load('172', 'Каталог');
    Tcp.lbTransportPort.Caption := Load('173', 'Транспорт');
    Tcp.cbUseMaxMemInQueues.Caption := Load('174', 'Ограничить память');
    Tcp.lbSizeMb.Caption := Prefixes[2];
    Tcp.cbUseRelayBandwidth.Caption := Load('176', 'Ограничить скорость');
    Tcp.cbUseNumCPUs.Caption := Load('177', 'Ограничить процессор');
    Tcp.lbNumCPUs.Caption := Load('178', 'Макс. ядер');
    Tcp.lbRelayBandwidthRate.Caption := Load('179', 'Средняя');
    Tcp.lbSpeed1.Caption := Prefixes[1] + '/' + TransStr('180');
    Tcp.lbSpeed2.Caption := Prefixes[1] + '/' + TransStr('180');
    Tcp.lbMaxMemInQueues.Caption := TransStr('175');
    Tcp.lbRelayBandwidthBurst.Caption := TransStr('175');
    Tcp.imUPnPTest.Hint := TransStr('181');
    Tcp.cbUseUPnP.Caption := Load('182', 'Пытаться автоматически настроить переадресацию портов');
    Tcp.cbPublishServerDescriptor.Caption := Load('183', 'Публиковать сервер в каталоге ретрансляторов');
    Tcp.cbUseDirPort.Caption := Load('184', 'Включить зеркало каталога ретрансляторов');
    Tcp.cbDirReqStatistics.Caption := Load('185', 'Собирать статистику запросов каталога');
    Tcp.cbHiddenServiceStatistics.Caption := Load('186', 'Собирать статистику о своей роли в качестве узла скрытого сервиса');
    Tcp.cbIPv6Exit.Caption := Load('187', 'Разрешить выход IPv6 трафика');
    Tcp.edNickname.TextHint := Load('188', 'Имя вашего узла');
    Tcp.edContactInfo.TextHint := Load('189', 'Электронный адрес');
    LoadList(Tcp.cbxServerMode, '205', '"Отключено","Ретранслятор","Выходной узел","Мост"');
    LoadList(Tcp.cbxExitPolicyType, '207', '"По умолчанию","Ограниченная","Настраиваемая"');
    Tcp.meMyFamily.TextHint.Text := TransStr('322');
    Tcp.lbBridgeDistribution.Caption := Load('425', 'Распространение');
    LoadList(Tcp.cbxBridgeDistribution, '426', '"Любое","Https","E-mail","Moat","Не распространять"');
    Tcp.cbUseAddress.Caption := Load('427', 'Задать внешний адрес вручную');
    Tcp.lbAddress.Caption := Load('428', 'Адрес');
    Tcp.edAddress.TextHint := Load('429', 'IP-адрес или имя узла');
    Tcp.lbPorts.Caption := Load('430', 'Настройка портов');
    Tcp.lbMaxAdvertisedBandwidth.Caption := Load('431', 'Рекламируемая');
    Tcp.lbSpeed4.Caption := Prefixes[1] + '/' + TransStr('180');
    Tcp.cbDirCache.Caption := Load('432', 'Использовать кэш каталога');
    Tcp.cbAssumeReachable.Caption := Load('433', 'Отключить проверку доступности сервера');
    Tcp.cbListenIPv6.Caption := Load('434', 'Прослушивать IPv6-адреса');
    Tcp.cbUseMyFamily.Caption := Load('435', 'Использовать семейство');
    Tcp.lbTotalMyFamily.Caption := TransStr('203') + ': ' + IntToStr(Tcp.meMyFamily.Lines.Count);

    Tcp.lbHsName.Caption := Load('190', 'Название');;
    Tcp.edHsName.TextHint := Load('191', 'Имя каталога');
    Tcp.cbHsMaxStreams.Caption := Load('192', 'Ограничить число соединений');
    Tcp.lbHsMaxStreams.Caption := Load('193', 'Соединений на цепочку');
    Tcp.lbHsVersion.Caption := Load('194', 'Версия протокола');
    Tcp.lbHsNumIntroductionPoints.Caption := Load('195', 'Точек входа');
    Tcp.lbRendPostPeriod.Caption := Load('196', 'Интервал публикации');
    Tcp.lbMinutes.Caption := TransStr('197');
    Tcp.lbHsSocket.Caption := Load('198', 'Сервис');
    Tcp.lbHsState.Caption := Load('199', 'Состояние');
    Tcp.lbHsVirtualPort.Caption := Load('200', 'Виртуальный порт');
    Tcp.gbHsEdit.Caption := Load('272', 'Панель редактирования');
    LoadList(Tcp.cbxHsState, '436', '"Включено","Выключено"');

    Tcp.cbUseTrackHostExits.Caption := Load('201', 'Сохранять выходной узел для указанных адресов');
    Tcp.lbTrackHostExitsExpire.Caption := Load('202', 'Менять по истечении');
    Tcp.lbSeconds4.Caption := TransStr('135');
    Tcp.lbTotalHosts.Caption := TransStr('203') + ': ' + IntToStr(Tcp.meTrackHostExits.Lines.Count);
    Tcp.lbTotalNodesList.Caption := TransStr('203') + ': ' + IntToStr(Tcp.meNodesList.Lines.Count);
    Tcp.meTrackHostExits.TextHint.Text := TransStr('208');
    Tcp.meNodesList.TextHint.Text := TransStr('209');
    Tcp.cbUseHiddenServiceVanguards.Caption := Load('437', 'Использовать авангарды для скрытых сервисов');
    Tcp.lbVanguardLayerType.Caption := Load('438', 'Изменять узел цепочки');
    LoadList(Tcp.cbxVanguardLayerType, '439', '"Автовыбор","Только второй","Только третий","Второй и третий"');
    Tcp.lbNodesListTypeCaption.Caption := Load('440', 'Выберите список для редактирования');
    Tcp.lbNodesListType.Caption := Load('441', 'Список');
    LoadList(Tcp.cbxNodesListType, '442', '"Входные узлы","Средние узлы","Выходные узлы","Запрещённые узлы"');
    Tcp.cbEnableNodesList.Caption := Load('443', 'Включить');

    Tcp.gbNetworkScanner.Caption := TransStr('444');
    Tcp.cbEnableDetectAliveNodes.Caption := Load('445', 'Включить определение живых узлов');
    Tcp.cbEnablePingMeasure.Caption := Load('446', 'Включить измерение пинга');
    Tcp.lbScanPortTimeout.Caption := Load('447', 'Таймаут подключения к порту');
    Tcp.lbScanPortAttempts.Caption := Load('448', 'Количество попыток соединения с портом');
    Tcp.lbScanPingTimeout.Caption := Load('449', 'Таймаут пинг-запросов');
    Tcp.lbScanPingAttempts.Caption := Load('450', 'Количество попыток измерить пинг');
    Tcp.lbDelayBetweenAttempts.Caption := Load('451', 'Задержка между попытками');
    Tcp.lbScanMaxThread.Caption := Load('452', 'Количество потоков сканирования');
    Tcp.lbScanPortionTimeout.Caption := Load('453', 'Задержка между порциями');
    Tcp.lbScanPortionSize.Caption := Load('454', 'Количество сканирований на порцию');
    Tcp.cbAutoScanNewNodes.Caption := Load('455', 'Автоматически определять пинг и живые узлы');
    Tcp.lbFullScanInterval.Caption := Load('456', 'Полное сканирование каждые');
    Tcp.lbNonResponsedScanInterval.Caption := Load('457', 'Сканирование узлов без ответа каждые');
    Tcp.lbPartialScansCounts.Caption := Load('458', 'Количество частичных сканирований');
    Tcp.lbMiliseconds1.Caption := TransStr('459');
    Tcp.lbMiliseconds2.Caption := TransStr('459');
    Tcp.lbMiliseconds3.Caption := TransStr('459');
    Tcp.lbMiliseconds4.Caption := TransStr('459');
    Tcp.lbHours1.Caption := TransStr('477');
    Tcp.lbHours2.Caption := TransStr('477');

    Tcp.gbTransports.Caption := Load('460', 'Подключаемые транспорты');
    Tcp.lbTransports.Caption := Load('461', 'Транспорты');
    Tcp.edTransports.TextHint := Load('462', 'Список поддерживаемых транспортов');
    Tcp.lbTransportsHandler.Caption := Load('463', 'Обработчик');
    Tcp.edTransportsHandler.TextHint := Load('464', 'Введите имя файла');
    Tcp.lbHandlerParams.Caption := Load('465', 'Параметры');
    Tcp.lbTransportType.Caption := TransStr('151');
    LoadList(Tcp.cbxTransportType, '466', '"Клиент","Сервер","Совмещённый"');

    Tcp.gbAutoSelectRouters.Caption := Load('467', 'Автоподбор роутеров');
    Tcp.lbAutoSelEntry.Caption := TransStr('288');
    Tcp.lbAutoSelMiddle.Caption := TransStr('289');
    Tcp.lbAutoSelExit.Caption := TransStr('290');
    Tcp.lbAutoSelMinWeight.Caption := Load('468', 'Вес');
    Tcp.lbAutoSelMaxPing.Caption := Load('469', 'Пинг');
    Tcp.lbCount1.Caption := TransStr('470');
    Tcp.lbCount2.Caption := TransStr('470');
    Tcp.lbCount3.Caption := TransStr('470');
    Tcp.lbSpeed5.Caption := Prefixes[2] + '/' + TransStr('180');
    Tcp.lbMiliseconds5.Caption := TransStr('459');
    Tcp.lbAutoSelPriority.Caption := Load('471', 'Приоритет');
    LoadList(Tcp.cbxAutoSelPriority, '472', '"Сбалансированный","Вес в консенсусе","Пинг до узла","Случайный"');
    Tcp.cbAutoSelStableOnly.Caption := Load('473', 'Только стабильные');
    Tcp.cbAutoSelFilterCountriesOnly.Caption := Load('474', 'Только страны из фильтра');
    Tcp.cbAutoSelUniqueNodes.Caption := Load('475', 'Только уникальные');
    Tcp.cbAutoSelNodesWithPingOnly.Caption := Load('476', 'Только отвечающие на пинг');
    Tcp.cbAutoSelMiddleNodesWithoutDir.Caption := Load('591', 'Средние узлы без каталогов');

    Tcp.gbTraffic.Caption := Load('211', 'Скорость');
    Tcp.lbDownloadSpeedCaption.Caption := TransStr('212') + ':';
    Tcp.lbUploadSpeedCaption.Caption := TransStr('213') + ':';
    Tcp.lbDLSpeed.Caption := BytesFormat(DLSpeed) + '/' + TransStr('180');
    Tcp.lbULSpeed.Caption := BytesFormat(ULSpeed) + '/' + TransStr('180');

    Tcp.gbMaxTraffic.Caption := TransStr('175');
    Tcp.lbMaxDLSpeedCaption.Caption := TransStr('212') + ':';
    Tcp.lbMaxULSpeedCaption.Caption := TransStr('213') + ':';
    Tcp.lbMaxDLSpeed.Caption := BytesFormat(MaxDLSpeed) + '/' + TransStr('180');
    Tcp.lbMaxULSpeed.Caption := BytesFormat(MaxULSpeed) + '/' + TransStr('180');

    Tcp.gbSession.Caption := Load('229', 'Итого за сеанс');
    Tcp.lbSessionDLCaption.Caption := TransStr('214') + ':';
    Tcp.lbSessionULCaption.Caption := TransStr('215') + ':';
    Tcp.lbSessionDL.Caption := BytesFormat(SessionDL);
    Tcp.lbSessionUL.Caption := BytesFormat(SessionUL);

    Tcp.gbTotal.Caption := Load('403', 'Итого за всё время');
    Tcp.gbTotal.Hint := Format(TransStr('402'), [DateTimeToStr(UnixToDateTime(TotalStartDate))]);
    Tcp.lbTotalDLCaption.Caption := TransStr('214') + ':';
    Tcp.lbTotalULCaption.Caption := TransStr('215') + ':';
    Tcp.lbTotalDL.Caption := BytesFormat(TotalDL);
    Tcp.lbTotalUL.Caption := BytesFormat(TotalUL);

    Tcp.gbInfo.Caption := Load('222', 'Сведения');
    Tcp.lbClientVersionCaption.Caption := Load('223', 'Версия клиента') + ':';
    Tcp.lbUserDirCaption.Caption := Load('224', 'Профиль') + ':';
    Tcp.lbClientVersion.Hint := Load('325', 'Перейти на страницу загрузки Tor');
    Tcp.lbUserDir.Hint := Load('227', 'Открыть папку профиля');
    Tcp.lbStatusProxyAddrCaption.Caption := Load('225', 'Встроенный прокси') + ':';
    Tcp.lbStatusProxyAddr.Hint := Load('228', 'Скопировать в буфер обмена');
    Tcp.lbStatusScannerCaption.Caption := TransStr('444') + ':';

    Tcp.gbServerInfo.Caption := Load('216', 'Сервер');
    Tcp.lbServerExternalIpCaption.Caption := Load('217', 'Внешний адрес') + ':';
    Tcp.lbFingerprintCaption.Caption := Load('218', 'Идентификатор') + ':';
    Tcp.lbBridgeCaption.Caption := Load('219', 'Адрес моста') + ':';
    if AlreadyStarted then
      Tcp.lbDetailsTime.Caption := TransStr('221') + ': ' + SeparateRight(Tcp.lbDetailsTime.Caption, ': ')
    else
    begin
      Tcp.lbDetailsTime.Caption := TransStr('221') + ': ' + TransStr('110');
      Tcp.lbClientVersion.Caption := TransStr('110');
      Tcp.lbServerExternalIp.Caption := TransStr('260');
      Tcp.lbFingerprint.Caption := TransStr('260');
      Tcp.lbBridge.Caption := TransStr('260');
    end;

    Tcp.gbSpeedGraph.Caption := Load('220', 'График скорости');

    Tcp.lbSpeed3.Caption := Prefixes[2] + '/' + TransStr('180');
    Tcp.btnShowNodes.Caption := TransStr('547');
    LoadList(Tcp.cbxRoutersQuery, '548', '"Хеш","Ник","IPv4","IPv6","OR-порт","DIR-порт","Версия","Пинг"');
    Tcp.edRoutersQuery.TextHint := Load('549', 'Введите запрос');
    Tcp.lbFavoritesEntry.Caption := TransStr('288') + ': ' + IntToStr(Tcp.lbFavoritesEntry.Tag);
    Tcp.lbFavoritesMiddle.Caption := TransStr('289') + ': ' + IntToStr(Tcp.lbFavoritesMiddle.Tag);
    Tcp.lbFavoritesExit.Caption := TransStr('290') + ': ' + IntToStr(Tcp.lbFavoritesExit.Tag);
    Tcp.lbFavoritesTotal.Caption := TransStr('203') + ': ' + IntToStr(Tcp.lbFavoritesTotal.Tag);
    Tcp.lbExcludeNodes.Caption := TransStr('287') + ': ' + IntToStr(Tcp.lbExcludeNodes.Tag);

    Tcp.miHsOpenDir.Caption := Load('273', 'Каталог сервиса');
    Tcp.miHsCopy.Caption := TransStr('274');
    Tcp.miHsInsert.Caption := TransStr('279');
    Tcp.miHsDelete.Caption := TransStr('280');
    Tcp.miHsClear.Caption := TransStr('278');

    Tcp.miServerCopy.Caption := TransStr('274');
    Tcp.miServerInfo.Caption := TransStr('281');

    Tcp.miCacheOperations.Caption := Load('478', 'Операции с кэшем');
    Tcp.miUpdateIpToCountryCache.Caption := Load('479', 'Обновить страны в сетевом кэше');;
    Tcp.miClearDNSCache.Caption := Load('283', 'Очистить DNS-кэш');
    Tcp.miClearServerCache.Caption := Load('480', 'Очистить серверный кэш');
    Tcp.miClearBridgeCacheUnnecessary.Caption := Load('481', 'Очистить кэш от ненужных мостов');
    Tcp.miClearBridgesCacheAll.Caption := Load('482', 'Очистить кэш всех мостов');
    Tcp.miClearPingCache.Caption := Load('483', 'Очистить кэш пинг-запросов');
    Tcp.miClearAliveCache.Caption := Load('484', 'Очистить кэш живых узлов');
    Tcp.miClearUnusedNetworkCache.Caption := Load('485', 'Очистить неиспользуемый сетевой кэш');
    Tcp.miResetScannerSchedule.Caption := Load('486', 'Сбросить расписание сканирования узлов');
    Tcp.miResetTotalsCounter.Caption := Load('487', 'Сбросить счётчик трафика');
    Tcp.miStartScan.Caption := Load('488', 'Запустить сканирование');
    Tcp.miScanNewNodes.Caption := Load('489', 'Новые узлы');
    Tcp.miScanNonResponsed.Caption := Load('490', 'Не отвечающие узлы');
    Tcp.miScanCachedBridges.Caption := Load('491', 'Кэшированные мосты');
    Tcp.miScanAll.Caption := Load('492', 'Все узлы');
    Tcp.miManualPingMeasure.Caption := Load('493', 'Измерять пинг');
    Tcp.miManualDetectAliveNodes.Caption := Load('494', 'Определять живые узлы');
    Tcp.miStopScan.Caption := Load('495', 'Остановить сканирование');
    Tcp.miResetGuards.Caption := Load('496', 'Сбросить сторожевые узлы');
    Tcp.miResetGuardsAll.Caption := Load('497', 'Все сторожевые узлы');
    Tcp.miResetGuardsBridges.Caption := Load('498', 'Мостовые узлы');
    Tcp.miResetGuardsRestricted.Caption := Load('499', 'Выбранные входные узлы');
    Tcp.miResetGuardsDefault.Caption := Load('500', 'Входные узлы по умолчанию');

    Tcp.miDetailsUpdateIp.Caption := TransStr('284');
    Tcp.miDetailsCopy.Caption := TransStr('274');
    Tcp.miDetailsAddToNodesList.Caption := TransStr('285');
    Tcp.miDetailsRelayInfo.Caption := TransStr('281');
    Tcp.miDetailsSelectTemplate.Caption := Load('286', 'Выбрать шаблон');

    Tcp.miGetBridges.Caption := Load('291', 'Получить мосты');
    Tcp.miGetBridgesSite.Caption := Load('501', 'Веб-сайт');
    Tcp.miGetBridgesTelegram.Caption := Load('502', 'Телеграм-канал');
    Tcp.miGetBridgesEmail.Caption := Load('503', 'Электронная почта');
    Tcp.miPreferWebTelegram.Caption := Load('504', 'Предпочитать веб-версию Телеграма');
    Tcp.miRequestObfuscatedBridges.Caption := Load('505', 'Запрашивать обфусцированные мосты');
    Tcp.miRequestIPv6Bridges.Caption := Load('506', 'Запрашивать IPv6-мосты');
    Tcp.miCut.Caption := TransStr('276');
    Tcp.miCopy.Caption := TransStr('274');
    Tcp.miPaste.Caption := TransStr('275');
    Tcp.miDelete.Caption := TransStr('280');
    Tcp.miSelectAll.Caption := TransStr('277');
    Tcp.miFind.Caption := TransStr('423');
    Tcp.miClear.Caption := TransStr('278');
    Tcp.miClearBridges.Caption := TransStr('278');
    Tcp.miClearBridgesNotAlive.Caption := Load('507', 'Не отвечающие на соединения');
    Tcp.miClearBridgesNonCached.Caption := Load('508', 'Отсутствующие в кэше');
    Tcp.miClearBridgesCached.Caption := Load('509', 'Найденные в кэше');
    Tcp.miClearBridgesAll.Caption := Load('510', 'Все мосты');

    Tcp.miLogOptions.Caption := TransStr('107');
    Tcp.miWriteLogFile.Caption := Load('292', 'Записывать в файл');
    Tcp.miAutoClear.Caption := Load('293', 'Очищать при каждом запуске');
    Tcp.miAutoScroll.Caption := Load('294', 'Автоматическая прокрутка');
    Tcp.miScrollBars.Caption := Load('295', 'Полоса прокрутки');
    Tcp.miSbVertical.Caption := Load('296', 'Вертикальная');
    Tcp.miSbHorizontal.Caption := Load('297', 'Горизонтальная');
    Tcp.miSbBoth.Caption := Load('298', 'Все');
    Tcp.miSbNone.Caption := Load('299', 'Нет');
    Tcp.miWordWrap.Caption := Load('300', 'Перенос строк');
    Tcp.miSafeLogging.Caption := Load('301', 'Скрывать сетевые адреса');
    Tcp.miLogLevel.Caption := Load('302', 'Уровень журналирования');
    Tcp.miDebug.Caption := Load('303', 'Отладка');
    Tcp.miInfo.Caption := Load('304', 'Информация');
    Tcp.miNotice.Caption := Load('305', 'Уведомления');
    Tcp.miWarn.Caption := Load('306', 'Предупреждения');
    Tcp.miErr.Caption := Load('307', 'Ошибки');
    Tcp.miOpenFileLog.Caption := Load('308', 'Открыть файл журнала');
    Tcp.miLogCopy.Caption := TransStr('274');
    Tcp.miLogSelectAll.Caption := TransStr('277');
    Tcp.miLogFind.Caption := TransStr('423');
    Tcp.miLogClear.Caption := TransStr('278');
    Tcp.miLogSeparate.Caption := Load('511', 'Разделение файла журнала');
    Tcp.miLogSeparateNone.Caption := Load('512', 'Не разделять');
    Tcp.miLogSeparateMonth.Caption := Load('513', 'По месяцам');
    Tcp.miLogSeparateDay.Caption := Load('514', 'По дням');

    Tcp.miStat.Caption := Load('309', 'Статистика');
    Tcp.miStatRelays.Caption := Load('310', 'Все');
    Tcp.miStatGuards.Caption := Load('311', 'Сторожевые');
    Tcp.miStatExit.Caption := Load('312', 'Выходные');
    Tcp.miStatAggregate.Caption := Load('313', 'Общая по странам');
    Tcp.miSaveTemplate.Caption := Load('314', 'Сохранить');
    Tcp.miLoadTemplate.Caption := Load('315', 'Загрузить');
    Tcp.miDeleteTemplate.Caption := TransStr('280');
    Tcp.miClearFilter.Caption := TransStr('278');
    Tcp.miClearFilterEntry.Caption := TransStr('288');
    Tcp.miClearFilterMiddle.Caption := TransStr('289');
    Tcp.miClearFilterExit.Caption := TransStr('290');
    Tcp.miClearFilterExclude.Caption := TransStr('287');
    Tcp.miClearFilterAll.Caption := Load('316', 'Все выбранные');
    Tcp.miFilterHideUnused.Caption := Load('163', 'Скрыть неиспользуемые страны');
    Tcp.miFilterScrollTop.Caption := TransStr('160');
    Tcp.miFilterOptions.Caption := TransStr('107');
    Tcp.miFilterSelectRow.Caption := TransStr('515');;
    Tcp.miNotLoadEmptyTplData.Caption := Load('516', 'Не загружать пустые данные шаблона');
    Tcp.miIgnoreTplLoadParamsOutsideTheFilter.Caption := Load('517', 'Игнорировать параметры загрузки из шаблона вне фильтра');
    Tcp.miReplaceDisabledFavoritesWithCountries.Caption := Load('518', 'Заменять выключенные списки узлов выбранными странами');
    Tcp.miTplSave.Caption := Load('519', 'Сохранять в шаблоне..');
    Tcp.miTplLoad.Caption := Load('520', 'Загружать из шаблона..');
    Tcp.miTplSaveCountries.Caption := TransStr('521');
    Tcp.miTplSaveRouters.Caption := TransStr('522');
    Tcp.miTplSaveExcludes.Caption := TransStr('523');
    Tcp.miTplSaveSA.Caption := TransStr('368');
    Tcp.miTplSaveUA.Caption := TransStr('369');
    Tcp.miTplLoadCountries.Caption := TransStr('521');
    Tcp.miTplLoadRouters.Caption := TransStr('522');
    Tcp.miTplLoadExcludes.Caption := TransStr('523');
    Tcp.miTplLoadSA.Caption := TransStr('368');
    Tcp.miTplLoadUA.Caption := TransStr('369');

    Tcp.miChangeCircuit.Caption := TransStr('103');
    Tcp.miShowStatus.Caption := TransStr('282');
    Tcp.miShowOptions.Caption := TransStr('107');
    Tcp.miShowLog.Caption := TransStr('108');
    Tcp.miShowCircuits.Caption := TransStr('327');
    Tcp.miShowRouters.Caption := TransStr('323');
    Tcp.miAbout.Caption := TransStr('355');
    Tcp.miExit.Caption := Load('319', 'Выход');

    Tcp.miCircuitsDestroy.Caption := TransStr('524');
    Tcp.miDestroyCircuit.Caption := Load('527', 'Цепочку');
    Tcp.miDestroyStreams.Caption := TransStr('528');
    Tcp.miDestroyExitCircuits.Caption := Load('529', 'Все выходные цепочки');
    Tcp.miCircuitsUpdateNow.Caption := TransStr('284');
    Tcp.miCircuitsSort.Caption := TransStr('525');
    Tcp.miCircuitsSortID.Caption := TransStr('221');
    Tcp.miCircuitsSortPurpose.Caption := TransStr('530');
    Tcp.miCircuitsSortStreams.Caption := TransStr('528');
    Tcp.miCircuitsSortDL.Caption := TransStr('214');
    Tcp.miCircuitsSortUL.Caption := TransStr('215');
    Tcp.miCircuitFilter.Caption := TransStr('526');
    Tcp.miCircOneHop.Caption := TransStr('331');
    Tcp.miCircInternal.Caption := TransStr('332');
    Tcp.miCircExit.Caption := TransStr('333');
    Tcp.miCircHsClientDir.Caption := TransStr('334');
    Tcp.miCircHsClientIntro.Caption := TransStr('335');
    Tcp.miCircHsClientRend.Caption := TransStr('336');
    Tcp.miCircHsServiceDir.Caption := TransStr('337');
    Tcp.miCircHsServiceIntro.Caption := TransStr('338');
    Tcp.miCircHsServiceRend.Caption := TransStr('339');
    Tcp.miCircHsVanguards.Caption := TransStr('340');
    Tcp.miCircPathBiasTesting.Caption := TransStr('341');
    Tcp.miCircTesting.Caption := TransStr('342');
    Tcp.miCircCircuitPadding.Caption := TransStr('343');
    Tcp.miCircMeasureTimeout.Caption := TransStr('344');
    Tcp.miCircOther.Caption := TransStr('345');
    Tcp.miCircSA.Caption := TransStr('368');
    Tcp.miCircUA.Caption := TransStr('369');
    Tcp.miCircuitOptions.Caption := TransStr('107');

    Tcp.miHideCircuitsWithoutStreams.Caption := Load('531', 'Скрывать цепочки без соединений');
    Tcp.miAlwaysShowExitCircuit.Caption := Load('532', 'Всегда показывать выходную цепочку');
    Tcp.miSelectExitCircuitWhetItChanges.Caption := Load('533', 'Выделять выходную цепочку при её изменении');
    Tcp.miShowCircuitsTraffic.Caption := Load('534', 'Показывать трафик цепочек');
    Tcp.miShowStreamsTraffic.Caption := Load('535', 'Показывать трафик соединений');
    Tcp.miShowStreamsInfo.Caption := Load('536', 'Показывать подробности соединений');
    Tcp.miCircuitsUpdateSpeed.Caption := Load('537', 'Скорость обновления');
    Tcp.miCircuitsUpdateHigh.Caption := Load('538', 'Высокая');
    Tcp.miCircuitsUpdateNormal.Caption := Load('539', 'Нормальная');
    Tcp.miCircuitsUpdateLow.Caption := Load('540', 'Низкая');
    Tcp.miCircuitsUpdateManual.Caption := Load('541', 'Обновлять вручную');

    Tcp.miStreamsDestroyStream.Caption := TransStr('524');
    Tcp.miStreamsOpenInBrowser.Caption := Load('542', 'Открыть в браузере');
    Tcp.miStreamsSort.Caption := TransStr('525');
    Tcp.miStreamsSortID.Caption := TransStr('221');
    Tcp.miStreamsSortTarget.Caption := TransStr('330');
    Tcp.miStreamsSortTrack.Caption := Load('543', 'Привязка к выходному узлу');
    Tcp.miStreamsSortStreams.Caption := TransStr('528');
    Tcp.miStreamsSortDL.Caption := TransStr('214');
    Tcp.miStreamsSortUL.Caption := TransStr('215');

    Tcp.miStreamsInfoDestroyStream.Caption := TransStr('524');
    Tcp.miStreamsInfoSort.Caption := TransStr('525');
    Tcp.miStreamsInfoSortID.Caption := TransStr('221');
    Tcp.miStreamsInfoSortSource.Caption := Load('544', 'Источник');
    Tcp.miStreamsInfoSortDest.Caption := Load('545', 'Назначение');
    Tcp.miStreamsInfoSortPurpose.Caption := TransStr('530');
    Tcp.miStreamsInfoSortDL.Caption := TransStr('214');
    Tcp.miStreamsInfoSortUL.Caption := TransStr('215');

    Tcp.miShowExit.Caption := Load('550', 'Выходной');
    Tcp.miShowGuard.Caption := Load('551', 'Сторожевой');
    Tcp.miShowOther.Caption := Load('552', 'Обычный');
    Tcp.miShowAuthority.Caption := Load('553', 'Корневой');
    Tcp.miShowBridge.Caption := Load('554', 'Кэшированный мост');
    Tcp.miShowFast.Caption := Load('555', 'Быстрый');
    Tcp.miShowStable.Caption := Load('556', 'Стабильный');
    Tcp.miShowV2Dir.Caption := Load('557', 'Вторая версия каталога');
    Tcp.miShowHSDir.Caption := Load('558', 'Каталог скрытых сервисов');
    Tcp.miShowDirMirror.Caption := Load('559', 'Зеркало каталога');
    Tcp.miShowRecommend.Caption := Load('560', 'Рекомендуемая версия');
    Tcp.miShowAlive.Caption := Load('561', 'Живой узел');
    Tcp.miReverseConditions.Caption := Load('562', 'Обратить условия фильтра');
    Tcp.miShowNodesUA.Caption := TransStr('369');

    Tcp.miRtResetFilter.Caption := Load('563', 'Сброс фильтров');
    Tcp.miRtCopy.Caption := TransStr('274');
    Tcp.miRtAddToNodesList.Caption := TransStr('285');
    Tcp.miRtSelectAsBridge.Caption := Load('564', 'Выбрать в качестве моста');
    Tcp.miRtDisableBridges.Caption := Load('565', 'Отменить использование мостов');
    Tcp.miRtRelayInfo.Caption := TransStr('281');
    Tcp.miRtFilters.Caption := TransStr('526');
    Tcp.miRtFiltersType.Caption := TransStr('547');
    Tcp.miRtFiltersCountry.Caption := TransStr('114');
    Tcp.miRtFiltersWeight.Caption := Load('566', 'Вес в консенсусе');
    Tcp.miRtFiltersQuery.Caption := Load('567', 'Запрос пользователя');
    Tcp.miRtFilterSA.Caption := TransStr('368');
    Tcp.miRtFilterUA.Caption := TransStr('369');
    Tcp.miRoutersOptions.Caption := TransStr('107');
    Tcp.miRoutersScrollTop.Caption := TransStr('160');
    Tcp.miRoutersSelectRow.Caption := TransStr('515');
    Tcp.miShowFlagsHint.Caption := Load('568', 'Показывать подсказки флагов при наведении мыши');
    Tcp.miLoadCachedRoutersOnStartup.Caption := Load('569', 'Загружать роутеры из кэша при запуске');
    Tcp.miDisableSelectionUnSuitableAsBridge.Caption := Load('570', 'Запретить выбор в качестве моста неподходящих узлов');
    Tcp.miConvertNodes.Caption := Load('571', 'Преобразовывать IP, CIDR и коды стран в хэши');
    Tcp.miEnableConvertNodesOnIncorrectClear.Caption := Load('572', 'При очистке неправильных узлов');
    Tcp.miEnableConvertNodesOnAddToNodesList.Caption := Load('573', 'При добавлении в список узлов');
    Tcp.miEnableConvertNodesOnRemoveFromNodesList.Caption := Load('574', 'При удалении из списка узлов');
    Tcp.miConvertIpNodes.Caption := Load('575', 'Преобразовывать IP-адреса');
    Tcp.miConvertCidrNodes.Caption := Load('576', 'Преобразовывать CIDR-маски');
    Tcp.miConvertCountryNodes.Caption := Load('577', 'Преобразовывать коды стран');
    Tcp.miIgnoreConvertExcludeNodes.Caption := Load('578', 'Исключить список запрещённых узлов');
    Tcp.miAvoidAddingIncorrectNodes.Caption := Load('579', 'Избегать добавление неправильных узлов');
    Tcp.miDisableFiltersOn.Caption := Load('580', 'Отключать фильтры при событии');
    Tcp.miDisableFiltersOnUserQuery.Caption := Load('581', 'Отправка запроса пользователя');
    Tcp.miDisableFiltersOnAuthorityOrBridge.Caption := Load('582', 'Выбор мостов или корневых узлов');
    Tcp.miRtSaveDefault.Caption := Load('583', 'Сохранить как фильтр по умолчанию');
    Tcp.miClearRouters.Caption := TransStr('278');
    Tcp.miClearRoutersEntry.Caption := TransStr('288');
    Tcp.miClearRoutersMiddle.Caption := TransStr('289');
    Tcp.miClearRoutersExit.Caption := TransStr('290');
    Tcp.miClearRoutersExclude.Caption := TransStr('287');
    Tcp.miClearRoutersFavorites.Caption := Load('584', 'Все избранные');
    Tcp.miClearRoutersIncorrect.Caption := Load('585', 'Неправильные узлы');
    Tcp.miClearRoutersAbsent.Caption := Load('586', 'Отсутствующие в консенсусе');
    Tcp.miAutoSelNodesType.Caption := Load('592', 'Изменять список узлов при автоподборе');
    Tcp.miAutoSelEntryEnabled.Caption := TransStr('288');
    Tcp.miAutoSelMiddleEnabled.Caption := TransStr('289');
    Tcp.miAutoSelExitEnabled.Caption := TransStr('290');
    Tcp.miAutoSelNodesSA.Caption := TransStr('368');
    Tcp.miAutoSelNodesUA.Caption := TransStr('369');

    Tcp.miTransportsInsert.Caption := TransStr('279');
    Tcp.miTransportsDelete.Caption := TransStr('280');
    Tcp.miTransportsOpenDir.Caption := Load('587', 'Каталог транспортов');
    Tcp.miTransportsReset.Caption := Load('588', 'Настройки по умолчанию');
    Tcp.miTransportsClear.Caption := TransStr('278');

    Tcp.miTrafficPeriod.Caption := Load('589', 'Период');
    Tcp.miPeriod1m.Caption := '1 ' + TransStr('197');
    Tcp.miPeriod5m.Caption := '5 ' + TransStr('197');
    Tcp.miPeriod15m.Caption := '15 ' + TransStr('197');
    Tcp.miPeriod30m.Caption := '30 ' + TransStr('197');
    Tcp.miPeriod1h.Caption := '1 ' + TransStr('477');
    Tcp.miPeriod3h.Caption := '3 ' + TransStr('477');
    Tcp.miPeriod6h.Caption := '6 ' + TransStr('477');
    Tcp.miPeriod12h.Caption := '12 ' + TransStr('477');
    Tcp.miPeriod24h.Caption := '24 ' + TransStr('477');
    Tcp.miSelectGraph.Caption := Load('590', 'Показывать графики');
    Tcp.miSelectGraphDL.Caption := TransStr('212');
    Tcp.miSelectGraphUL.Caption := TransStr('213');

    if ValidInt(TransStr('Locale'), 0, 65535) then
      CurrentLanguage := StrToInt(TransStr('Locale'))
    else
      CurrentLanguage := GetSystemDefaultLangID;

    Tcp.lbExitCountry.Font.Style := [fsUnderline];
    Tcp.lbExitIp.Font.Style := [fsUnderline];

    if Tcp.cbxThemes.ItemIndex = 0 then
    begin
      Tcp.cbxThemes.Items[0] := TransStr('104');
      Tcp.cbxThemes.ItemIndex := 0;
    end;

    if Load('UseDefaultCountries', '0') = '1' then
      CurrentTranslate := 'DefaultCountries';

    LoadStr('au','Австралия');
    LoadStr('at','Австрия');
    LoadStr('az','Азербайджан');
    LoadStr('ax','Аланды');
    LoadStr('al','Албания');
    LoadStr('dz','Алжир');
    LoadStr('as','Американское Самоа');
    LoadStr('ai','Ангилья');
    LoadStr('ao','Ангола');
    LoadStr('ad','Андорра');
    LoadStr('aq','Антарктида');
    LoadStr('ag','Антигуа и Барбуда');
    LoadStr('ar','Аргентина');
    LoadStr('am','Армения');
    LoadStr('aw','Аруба');
    LoadStr('af','Афганистан');
    LoadStr('bs','Багамы');
    LoadStr('bd','Бангладеш');
    LoadStr('bb','Барбадос');
    LoadStr('bh','Бахрейн');
    LoadStr('bz','Белиз');
    LoadStr('by','Беларусь');
    LoadStr('be','Бельгия');
    LoadStr('bj','Бенин');
    LoadStr('bm','Бермудские острова');
    LoadStr('bg','Болгария');
    LoadStr('bo','Боливия');
    LoadStr('bq','Бонайре, Синт-Эстатиус и Саба');
    LoadStr('ba','Босния и Герцеговина');
    LoadStr('bw','Ботсвана');
    LoadStr('br','Бразилия');
    LoadStr('io','Британская территория в Индийском океане');
    LoadStr('bn','Бруней');
    LoadStr('bf','Буркина Фасо');
    LoadStr('bi','Бурунди');
    LoadStr('bt','Бутан');
    LoadStr('vu','Вануату');
    LoadStr('va','Ватикан');
    LoadStr('gb','Великобритания');
    LoadStr('hu','Венгрия');
    LoadStr('ve','Венесуэла');
    LoadStr('vg','Виргинские острова (Великобритания)');
    LoadStr('vi','Виргинские острова (США)');
    LoadStr('um','Внешние малые острова (США)');
    LoadStr('tl','Восточный Тимор');
    LoadStr('vn','Вьетнам');
    LoadStr('ga','Габон');
    LoadStr('gy','Гайана');
    LoadStr('ht','Гаити');
    LoadStr('gm','Гамбия');
    LoadStr('gh','Гана');
    LoadStr('gp','Гваделупа');
    LoadStr('gt','Гватемала');
    LoadStr('gf','Французская Гвиана');
    LoadStr('gn','Гвинея');
    LoadStr('gw','Гвинея-Биссау');
    LoadStr('de','Германия');
    LoadStr('gg','Гернси');
    LoadStr('gi','Гибралтар');
    LoadStr('hn','Гондурас');
    LoadStr('hk','Гонконг');
    LoadStr('ps','Палестина');
    LoadStr('gd','Гренада');
    LoadStr('gl','Гренландия');
    LoadStr('gr','Греция');
    LoadStr('ge','Грузия');
    LoadStr('gu','Гуам');
    LoadStr('dk','Дания');
    LoadStr('cd','Демократическая Республика Конго');
    LoadStr('je','Джерси');
    LoadStr('dj','Джибути');
    LoadStr('dm','Остров Доминика');
    LoadStr('do','Доминиканская Республика');
    LoadStr('eg','Египет');
    LoadStr('zm','Замбия');
    LoadStr('zw','Зимбабве');
    LoadStr('ye','Йемен');
    LoadStr('il','Израиль');
    LoadStr('in','Индия');
    LoadStr('id','Индонезия');
    LoadStr('jo','Иордания');
    LoadStr('iq','Ирак');
    LoadStr('ir','Иран');
    LoadStr('ie','Ирландия');
    LoadStr('is','Исландия');
    LoadStr('es','Испания');
    LoadStr('it','Италия');
    LoadStr('cv','Кабо-Верде');
    LoadStr('kz','Казахстан');
    LoadStr('kh','Камбоджа');
    LoadStr('cm','Камерун');
    LoadStr('ca','Канада');
    LoadStr('qa','Катар');
    LoadStr('ke','Кения');
    LoadStr('cy','Кипр');
    LoadStr('kg','Кыргызстан');
    LoadStr('ki','Кирибати');
    LoadStr('cn','Китай');
    LoadStr('kp','Северная Корея');
    LoadStr('cc','Кокосовые острова');
    LoadStr('co','Колумбия');
    LoadStr('km','Коморские острова');
    LoadStr('cr','Коста-Рика');
    LoadStr('ci','Кот-д''Ивуар');
    LoadStr('cu','Куба');
    LoadStr('kw','Кувейт');
    LoadStr('cw','Кюрасао');
    LoadStr('la','Лаос');
    LoadStr('lv','Латвия');
    LoadStr('ls','Лесото');
    LoadStr('lr','Либерия');
    LoadStr('lb','Ливан');
    LoadStr('ly','Ливия');
    LoadStr('lt','Литва');
    LoadStr('li','Лихтенштейн');
    LoadStr('lu','Люксембург');
    LoadStr('mu','Маврикий');
    LoadStr('mr','Мавритания');
    LoadStr('mg','Мадагаскар');
    LoadStr('yt','Майотта');
    LoadStr('mo','Макао');
    LoadStr('mk','Северная Македония');
    LoadStr('mw','Малави');
    LoadStr('my','Малайзия');
    LoadStr('ml','Мали');
    LoadStr('mv','Мальдивские острова');
    LoadStr('mt','Мальта');
    LoadStr('ma','Марокко');
    LoadStr('mq','Мартиника');
    LoadStr('mh','Маршалловы острова');
    LoadStr('mx','Мексика');
    LoadStr('fm','Микронезия');
    LoadStr('mz','Мозамбик');
    LoadStr('md','Молдова');
    LoadStr('mc','Монако');
    LoadStr('mn','Монголия');
    LoadStr('ms','Монсеррат');
    LoadStr('mm','Мьянма');
    LoadStr('na','Намибия');
    LoadStr('nr','Науру');
    LoadStr('np','Непал');
    LoadStr('ne','Нигер');
    LoadStr('ng','Нигерия');
    LoadStr('nl','Нидерланды');
    LoadStr('ni','Никарагуа');
    LoadStr('nu','Ниуе');
    LoadStr('nz','Новая Зеландия');
    LoadStr('nc','Новая Каледония');
    LoadStr('no','Норвегия');
    LoadStr('ae','ОАЭ');
    LoadStr('om','Оман');
    LoadStr('bv','Остров Буве');
    LoadStr('im','Остров Мэн');
    LoadStr('nf','Остров Норфолк');
    LoadStr('cx','Остров Рождества');
    LoadStr('ky','Каймановы острова');
    LoadStr('ck','Острова Кука');
    LoadStr('pn','Питкэрн');
    LoadStr('sh','Остров Святой Елены');
    LoadStr('pk','Пакистан');
    LoadStr('pw','Палау');
    LoadStr('pa','Панама');
    LoadStr('pg','Папуа-Новая Гвинея');
    LoadStr('py','Парагвай');
    LoadStr('pe','Перу');
    LoadStr('pl','Польша');
    LoadStr('pt','Португалия');
    LoadStr('pr','Пуэрто-Рико');
    LoadStr('cg','Конго');
    LoadStr('kr','Южная Корея');
    LoadStr('re','Реюньон');
    LoadStr('ru','Россия');
    LoadStr('rw','Руанда');
    LoadStr('ro','Румыния');
    LoadStr('eh','Западная Сахара');
    LoadStr('sv','Сальвадор');
    LoadStr('ws','Самоа');
    LoadStr('sm','Сан-Марино');
    LoadStr('st','Сан-Томе и Принсипе');
    LoadStr('sa','Саудовская Аравия');
    LoadStr('sz','Свазиленд');
    LoadStr('mp','Северные Марианские острова');
    LoadStr('sc','Сейшельские острова');
    LoadStr('bl','Остров Святого Бартоломея');
    LoadStr('sn','Сенегал');
    LoadStr('mf','Остров Святого Мартина');
    LoadStr('pm','Сен-Пьер и Микелон');
    LoadStr('vc','Сент-Винсент и Гренадины');
    LoadStr('kn','Сент-Киттс и Невис');
    LoadStr('lc','Сент-Люсия');
    LoadStr('rs','Сербия');
    LoadStr('sg','Сингапур');
    LoadStr('sx','Синт-Мартен');
    LoadStr('sy','Сирия');
    LoadStr('sk','Словакия');
    LoadStr('si','Словения');
    LoadStr('sb','Соломонские острова');
    LoadStr('so','Сомали');
    LoadStr('sd','Судан');
    LoadStr('sr','Суринам');
    LoadStr('us','США');
    LoadStr('sl','Сьерра-Леоне');
    LoadStr('tj','Таджикистан');
    LoadStr('tw','Тайвань');
    LoadStr('th','Тайланд');
    LoadStr('tz','Танзания');
    LoadStr('tc','Острова Тёркс и Кайкос');
    LoadStr('tg','Того');
    LoadStr('tk','Токелау');
    LoadStr('to','Тонга');
    LoadStr('tt','Тринидад и Тобаго');
    LoadStr('tv','Тувалу');
    LoadStr('tn','Тунис');
    LoadStr('tm','Туркменистан');
    LoadStr('tr','Турция');
    LoadStr('ug','Уганда');
    LoadStr('uz','Узбекистан');
    LoadStr('ua','Украина');
    LoadStr('wf','Уоллис и Футуна');
    LoadStr('uy','Уругвай');
    LoadStr('fo','Фарерские острова');
    LoadStr('fj','Фиджи');
    LoadStr('ph','Филиппины');
    LoadStr('fi','Финляндия');
    LoadStr('fk','Фолклендские острова');
    LoadStr('fr','Франция');
    LoadStr('pf','Французская Полинезия');
    LoadStr('tf','Французские Южные Территории');
    LoadStr('hm','Острова Херд и Макдональд');
    LoadStr('hr','Хорватия');
    LoadStr('cf','ЦАР');
    LoadStr('td','Чад');
    LoadStr('me','Черногория');
    LoadStr('cz','Чешская Республика');
    LoadStr('cl','Чили');
    LoadStr('ch','Швейцария');
    LoadStr('se','Швеция');
    LoadStr('sj','Свальбард и Ян-Майен');
    LoadStr('lk','Шри-Ланка');
    LoadStr('ec','Эквадор');
    LoadStr('gq','Экваториальная Гвинея');
    LoadStr('er','Эритрея');
    LoadStr('ee','Эстония');
    LoadStr('et','Эфиопия');
    LoadStr('za','ЮАР');
    LoadStr('gs','Южная Джорджия и Южные Сандвичевы острова');
    LoadStr('ss','Южный Судан');
    LoadStr('jm','Ямайка');
    LoadStr('jp','Япония');
    LoadStr('??','Неизвестная');
    LoadStr('eu','Европейский союз');

  finally
    LangIniFile.Free;
  end;
end;

end.



