
<img width="256" height="256" alt="appicon" src="https://github.com/user-attachments/assets/0072b50c-9409-4683-87c1-8ff3d041e3ce" />


MyBodyMap

MyBodyMap — личный помощник для отслеживания физического прогресса — современное iOS-приложение на SwiftUI + TCA

⸻

🚀 О проекте

MyBodyMap — это модульное приложение для отслеживания физических показателей, динамики тела, привычек и питьевого режима.
Архитектура построена на современных фреймворках:

    •    SwiftUI 
    •    The Composable Architecture (TCA 1.20+)
    •    Realm 
    •    Charts 
    •    HealthKit 


⸻

🏠 Измерения тела

Описание:

    •    При запуске пользователь попадает на главный экран с визуализацией текущих измерений тела.
    •    Все параметры отображаются на кастомной фигуре-силуэте, а также в списке.
    •    Быстрый доступ к добавлению нового значения (например, обхват талии, рост, вес).
    •    Синхронизация веса роста и индекса массы тела с HealthKit.

<img width="220" height="476" alt="male_dark" src="https://github.com/user-attachments/assets/1b9f6ff0-872d-4155-826d-454e0f60ef6a" /> <img width="220" height="476" alt="female_dark" src="https://github.com/user-attachments/assets/2c31525e-abd6-4ac7-8f8c-8c127734bc9f" />

⸻

📈 Аналитика и динамика — Тренды

Возможности:

    •    Современные интерактивные графики (Charts), можно скроллить по неделям и месяцам.
    •    Отображение трендов веса, объёмов, роста и др. с наглядной динамикой.
    •    Всплывающие окна для просмотра подробной статистики.
    •    Красивые цветовые акценты в зависимости от результата.

<img width="220" height="476" alt="trends" src="https://github.com/user-attachments/assets/02a07553-1809-46b3-86f0-dcbc3fb562e2" /> <img width="220" height="476" alt="trendcard" src="https://github.com/user-attachments/assets/ec1fe548-0111-413e-93b8-9519a716c964" />



⸻

💧 Водный трекер — WaterTracker

Описание:

    •    Интуитивный прогресс-бар — визуализация количества выпитой воды по отношению к цели.
    •    Быстрые кнопки для добавления воды и других напитков (чай, кофе и пр.).
    •    Поддержка ввода произвольных напитков, добавления через штрихкод (OpenFoodFacts API).
    •    Отдельный экран для изменения ежедневной цели.

<img width="220" height="476" alt="watertrackerfilled" src="https://github.com/user-attachments/assets/bb61428f-7225-49fd-9cb0-915fe305a469" /> <img width="220" height="476" alt="drinklist" src="https://github.com/user-attachments/assets/c30c51dd-c2e6-4ead-a101-925a2394485a" />



⸻

👤 Профиль и цели

    •    Хранение и отображение целей пользователя (например, целевой вес, объем талии).
    •    Быстрая настройка основных параметров и переключение между целями.

<img width="220" height="476" alt="profile" src="https://github.com/user-attachments/assets/6c8d4fda-d3f4-40d2-b1c7-fa5f9af80b38" />


⸻

🗂 Архитектура и структура кода

    •    Modular TCA: каждый экран — отдельная Feature/Reducer/State/Action, чёткая декомпозиция.
    •    Single source of truth: все состояния в Store, все экраны используют Bindable Stores и Scope.
    •    Realm: надёжное хранение истории, полная автономность приложения.
    •    Charts: динамическое построение графиков за неделю/месяц с анимацией и скроллингом.
    •    Reusable UI: кастомные CardView, ButtonStyle, Picker, Segmented Control и пр.
    •    HealthKit (опционально): интеграция для автоматического обмена измерениями.
    •    Dependency Injection через TCA: легко заменять сервисы на мок/тестовые реализации.

⸻

🛡 Ключевые преимущества

    •    Современный UX и быстрый отклик на действия.
    •    Легко расширять — каждый модуль независим.
    •    Надёжное хранение данных даже без интернета.
    •    Минимальные зависимости и чистый open-source стек.
    •    Реализованы лучшие практики из официальной документации Apple и Point-Free.

⸻

📲 Скриншоты интерфейса

<img width="220" height="476" alt="male_light" src="https://github.com/user-attachments/assets/45b61d5f-d55e-4df0-9895-565d51f94994" /> <img width="220" height="476" alt="measures" src="https://github.com/user-attachments/assets/c73bc2c1-23e0-4f5a-95fa-cd21a694390d" /> <img width="220" height="476" alt="alltrends" src="https://github.com/user-attachments/assets/8befddc8-ab71-4337-8b8e-6cc12f822926" /> <img width="220" height="476" alt="watertracker" src="https://github.com/user-attachments/assets/4883c284-5155-4f18-a1af-e513d4cebd66" />

⸻

🧩 Структура проекта (кратко)

    •    App/MyBodyMapApp.swift — точка входа, root Store, стартовый роутинг
    •    Features/Measures/ — измерения тела (главный экран, фигура, история, ввод)
    •    Features/Trends/ — аналитика, графики, тренды
    •    Features/WaterTracker/ — трекер воды, напитки, цель, история, сканер штрихкодов
    •    Features/Profile/ — профиль, цели, настройки
    •    CommonViews/ — переиспользуемые компоненты: CardView, CustomButtonStyleView, Pickers и др.
    •    Services/ — Realm, HealthKit, API

⸻

⚙️ Сборка и запуск

    •    Xcode 16.4 и новее
    •    iOS 18.5 (или последняя доступная версия)
    •    Сторонние зависимости: TCA 1.20+, RealmSwift, Charts

⸻

🎓 Особенности 

    •    Проект реально пригоден для продакшена — легко добавить новые трекеры (еда, спорт, сон), новые типы графиков, синхронизацию с другими устройствами

⸻

📝 Контакты и авторство

Иван Парамонихин, 2025
Репозиторий: github.com/IParamonikhin/MyBodyMap

⸻
