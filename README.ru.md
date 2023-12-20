<a name="readme-top"></a>
<div align="center">

[![Contributors](https://img.shields.io/github/contributors/abysshint/tor-control-panel.svg?style=for-the-badge)](https://github.com/abysshint/tor-control-panel/graphs/contributors)
[![Forks](https://img.shields.io/github/forks/abysshint/tor-control-panel.svg?style=for-the-badge)](https://github.com/abysshint/tor-control-panel/network/members)
[![MIT License](https://img.shields.io/github/license/abysshint/tor-control-panel.svg?style=for-the-badge)](https://github.com/abysshint/tor-control-panel/blob/main/LICENSE)
[![Stargazers](https://img.shields.io/github/stars/abysshint/tor-control-panel.svg?style=for-the-badge)](https://github.com/abysshint/tor-control-panel/stargazers)
[![Downloads](https://img.shields.io/github/downloads/abysshint/tor-control-panel/total.svg?style=for-the-badge)](https://github.com/abysshint/tor-control-panel/releases)

</div>

<div align="center">
  <a href="https://github.com/abysshint/tor-control-panel"><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/common/tcp-logo.png" alt="Logo" width="100" height="100"></a>
  <h3 align="center">Панель управления Tor</h3>
  <p align="center">
    Windows GUI-клиент для Tor Expert Bundle
    <br />
    <br />
    Язык: 
	  <a href="https://github.com/abysshint/tor-control-panel#readme-top">English</a> · 
      <a href="https://github.com/abysshint/tor-control-panel/blob/main/README.ru.md#readme-top">Русский</a>
  </p>
</div>

## Оглавление

* [Обзор](#обзор)
* [Системные требования](#системные-требования)
* [Особенности программы](#особенности-программы)
* [Скриншоты](#скриншоты)
* [Сборка проекта](#сборка-проекта)
* [Конфиденциальность](#конфиденциальность)
* [Лицензия](#лицензия)
* [Ссылки](#ссылки)

## Обзор
<u>Панель управления Tor</u> - это бесплатный и простой инструмент с графическим интерфейсом для настройки, управления и мониторинга работы [Tor Expert Bundle](https://www.torproject.org/download/tor/) в операционной системе Windows. Работа программы основана исключительно на редактировании конфигурационных файлов, разборе локальных кэшей дескрипторов и отправке запросов/получении ответов через управляющий порт. Программа имеет приятный и интуитивно-понятный интерфейс, который поможет вам использовать больше возможностей сети Tor, прилагая при этом минимум усилий.

## Системные требования
* Операционная система: Windows 7 и выше
* Версия Tor: 0.4.0.5 и выше

    > Примечание: программа может работать на Windows XP и Vista, однако tor и подключаемые транспорты из официального Tor Expert Bundle больше не поддерживают эти операционные системы.
<p align="right">[<a href="#readme-top">↑ Вверх</a>]</p>

## Особенности программы
* Возможность подключения к сети Tor через мосты и прокси-сервер
* Возможность выбирать в качестве узлов не только страны, но и хэши, IP-адреса и CIDR-маски
* Возможность сброса сторожевых узлов
* Возможность сканировать узлы на доступность портов и измерять пинг
* Возможность управлять скрытыми сервисами
* Возможность использовать избранные сторожевые узлы в качестве Vanguards
* Возможность добавлять и настраивать запуск подключаемых транспортов
* Возможность извлечения отображаемых данных в виде текстовых списков
* Сохранение/загрузка своих списков входных, промежуточных, выходных и запрещённых узлов
* Автоматический подбор узлов на основе пользовательских настроек
* Запуск нескольких копий программы с разными профилями
* Отображение журнала сообщений Tor и сохранение его в файл
* Настройка работы Tor в режиме сервера (Выходной узел, Ретранслятор и мост)
* Просмотр информации по всем узлам текущего консенсуса (Ник, IP-адрес, Страна, Версия, Вес в консенсусе, Пинг и тд.)
* Удобная система фильтрации, поиска и сортировки, помогающая выбрать наиболее подходящие вам узлы
* Просмотр и закрытие цепочек/активных соединений
* Отображение статистики по трафику в виде графика и цифровых данных
* Удобная система управления мостами (кэширование, исключение неподходящих, выбор приоритета)
* Программа портативная, установка не требуется, где её запустили там она и работает
* Поддержка визуальных тем оформления
* Мультиязычный интерфейс с возможностью добавлять новые локализации
<p align="right">[<a href="#readme-top">↑ Вверх</a>]</p>

## Скриншоты
<table border="0">
  <tr align="center">
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/russian/tcp-options-general.png" alt="tcp-options-general"></td>	
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/russian/tcp-options-network.png" alt="tcp-options-network"></td>  
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/russian/tcp-options-filter.png" alt="tcp-options-filter"></td>
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/russian/tcp-options-server.png" alt="tcp-options-server"></td>	
  </tr>
  <tr align="center">
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/russian/tcp-circuits.png" alt="tcp-circuits"></td>
    <td colspan="2"><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/russian/tcp-status.png" alt="tcp-status"></td>
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/russian/tcp-relays.png" alt="tcp-relays"></td>
  </tr>
  <tr align="center">
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/russian/tcp-options-hs.png" alt="tcp-options-hs"><br /></td>
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/russian/tcp-options-lists.png" alt="tcp-options-lists"></td>
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/russian/tcp-options-other.png" alt="tcp-options-other"></td>
     <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/russian/tcp-log.png" alt="tcp-log"></td>	
  </tr>
</table>
<p align="right">[<a href="#readme-top">↑ Вверх</a>]</p>

## Сборка проекта
1. Установите интегрированную среду разработки [Delphi 11.3 CE](https://www.embarcadero.com/ru/products/delphi/starter/free-download)
    > Внимание! Сборка проекта в других версиях Delphi не тестировалась и может привести к самым неожиданным результатам
2. Загрузите и установите в Delphi библиотеку [Ararat Synapse](https://sourceforge.net/p/synalist/code/HEAD/tree/trunk/)

    * Создайте папку **Synapse** и извлеките в неё файлы из архива **synalist-code-r000-trunk.zip**
	
      `C:\Program Files (x86)\Embarcadero\Studio\21.0\source\Synapse`
	  
    * Откройте настройки Delphi и добавьте путь **$(BDS)\source\Synapse** в списки **Library path** и **Browsing path** для платформ: Windows 32-bit и Windows 64-bit
	
      `[Tools] → [Options] → [Language] → [Delphi] → [Library]`
	  
3. Откройте файл **TorControlPanel.dproj**, выберите платформу и скомпилируйте проект нажатием кнопки **[Run]**
<p align="right">[<a href="#readme-top">↑ Вверх</a>]</p>

## Конфиденциальность
Программа не имеет прямого доступа к передаваемым данным пользователя, не требует прав администратора, не изменяет никакие системные настройки операционной системы, включая системный прокси-сервер, не собирает никаких статистических данных об использовании

## Лицензия
Эта программа является свободным программным обеспечением и распространяется по [лицензии MIT](https://github.com/abysshint/tor-control-panel/blob/main/LICENSE)

## Ссылки
* [Мануал по Tor](https://man.archlinux.org/man/tor.1)
* [Спецификации и предложения Tor](https://gitlab.torproject.org/tpo/core/torspec)
* [Сервер дистрибутивов проекта Tor Project](https://dist.torproject.org/)
* [Файловый архив проекта Tor Project](https://archive.torproject.org/tor-package-archive/)
* [Свежие GeoIp-базы](https://tpo.pages.torproject.net/network-health/metrics/geoip-data/)
* [Актуальная версия Tor Expert Bundle](https://www.torproject.org/ru/download/tor/)
<p align="right">[<a href="#readme-top">↑ Вверх</a>]</p>
