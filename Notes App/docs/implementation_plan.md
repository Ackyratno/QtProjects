# Implementation Plan: Notes App (Level 2 — Работа с данными)

Приложение заметок (**Notes App**) с полноценным циклом **CRUD** (создание, чтение, обновление, удаление) на базе **SQLite** и архитектурного паттерна **Repository Pattern**, с динамическим и современным интерфейсом на **Qt Quick / QML**.

Учебная цель: Освоить интеграцию `C++ (QSqlDatabase, QAbstractListModel)` с `QML (ListView, Delegates, Controls)`, выстроить слоистую архитектуру приложения и создать готовое кроссплатформенное приложение.

---

## Архитектура проекта

```
                           +------------------------+
                           |     QML Interface      |
                           |  (Main.qml, Pages,     |
                           |   Components, Theme)   |
                           +-----------+------------+
                                       |
                           (Model / View Binding)
                                       v
                           +------------------------+
                           |       NoteModel        |
                           | (QAbstractListModel)   |
                           +-----------+------------+
                                       |
                              (Repository Calls)
                                       v
                           +------------------------+
                           |    INoteRepository     |
                           |      (Interface)       |
                           +-----------+------------+
                                       |
                                       v
                           +------------------------+
                           |  SqliteNoteRepository  |
                           | (QSqlDatabase/SQLite)  |
                           +------------------------+
```

### Разделение обязанностей:
* **Вы (Пользователь):** C++Backend (`Note`, `INoteRepository`, `SqliteNoteRepository`, `NoteModel`, регистрация в `main.cpp`).
* **Я (AI Агент):** QML UI/UX (`Theme.qml`, `NoteCardDelegate.qml`, `NoteListPage.qml`, `NoteEditorDialog.qml`, стилизация, анимации).

---

## Структура файлов проекта

```
NotesApp/
├── CMakeLists.txt              # [USER] Конфигурация сборки CMake
├── main.cpp                    # [USER] Точка входа, инициализация QML и бэкенда
│
├── cpp/
│   ├── models/
│   │   ├── Note.h              # [USER] C++ структура заметки
│   │   ├── NoteModel.h         # [USER] QAbstractListModel для QML
│   │   └── NoteModel.cpp       # [USER] Реализация методов модели
│   │
│   └── repository/
│       ├── INoteRepository.h   # [USER] Абстрактный интерфейс репозитория
│       ├── SqliteNoteRepository.h # [USER] Заголовок работы с SQLite
│       └── SqliteNoteRepository.cpp # [USER] Реализация SQL запросов
│
└── qml/
    ├── Main.qml                # [USER/AI] Главное окно приложения
    ├── themes/
    │   └── Theme.qml           # [AI] Дизайн-система (цвета, шрифты, отступы)
    ├── components/
    │   ├── NoteCardDelegate.qml # [AI] Карточка заметки в списке
    │   ├── CustomButton.qml     # [AI] Стилизованные кнопки
    │   └── SearchHeader.qml     # [AI] Шапка с поиском
    └── pages/
        ├── NoteListPage.qml    # [AI] Страница списка заметок
        └── NoteEditorDialog.qml# [AI] Окно/Диалог редактирования и создания
```

---

## Пошаговый план разработки (Roadmap)

### Этап 1: Структурирование проекта и базовый скелет (CMake + QML)
* **Что нужно изучить:**
  * Основы CMake для Qt 6 QML (`qt_add_executable`, `qt_add_qml_module`).
  * Точка входа `main.cpp` и `QQmlApplicationEngine`.
* **Что делает Пользователь:**
  * Настраивает `CMakeLists.txt` с подключением компонентов `Core`, `Gui`, `Qml`, `Quick`, `Sql`.
  * Создает `main.cpp` для запуска QML движка.
* **Что делает AI:**
  * Разворачивает начальную файловую структуру проекта.
  * Создает каркас `qml/Main.qml` с пустым окном и приветственным текстом.
* **Что получается в итоге:** Запускаемое окно приложения с базовой конфигурацией CMake.

---

### Этап 2: Проектирование сущности Note и интерфейса Репозитория
* **Что нужно изучить:**
  * Паттерн **Repository Pattern** (зачем разделять логику хранения и представление).
  * Чисто виртуальные классы и интерфейсы в C++.
  * Работу с типом `QDateTime` и идентификаторами `qint64`.
* **Что делает Пользователь:**
  * Создает `struct Note` (поля `id`, `title`, `content`, `createdAt`, `updatedAt`).
  * Создает интерфейс `INoteRepository` с методами CRUD:
    * `virtual std::vector<Note> getAllNotes() = 0;`
    * `virtual std::optional<Note> getNoteById(qint64 id) = 0;`
    * `virtual qint64 addNote(const Note& note) = 0;`
    * `virtual bool updateNote(const Note& note) = 0;`
    * `virtual bool deleteNote(qint64 id) = 0;`
* **Что делает AI:**
  * Помогает с выбором оптимальных C++ типов данных для взаимодействия с Qt и QML.
  * Проводит ревью класса данных и репозитория.
* **Что получается в итоге:** Четкий контракт архитектуры бэкенда.

---

### Этап 3: Реализация работы с SQLite (SqliteNoteRepository)
* **Что нужно изучить:**
  * Основы SQL (команды `CREATE TABLE`, `SELECT`, `INSERT`, `UPDATE`, `DELETE`).
  * Классы Qt для работы с БД: `QSqlDatabase`, `QSqlQuery`, `QSqlError`.
  * Использование подготавливаемых запросов (`QSqlQuery::prepare`, `bindValue`) для безопасности и производительности.
* **Что делает Пользователь:**
  * Реализует класс `SqliteNoteRepository : public INoteRepository`.
  * Написывает создание таблицы `notes` при первом запуске.
  * Реализует методы добавления, выборки, редактирования и удаления заметок в базе данных SQLite.
* **Что делает AI:**
  * Проверяет безопасность SQL-запросов (защита от SQL-инъекций).
  * Подсказывает методы корректной обработки ошибок `QSqlDatabase`.
* **Что получается в итоге:** Рабочий C++ класс для сохранения заметок в локальный файл базы данных `notes.db`.

---

### Этап 4: Мост между C++ и QML (NoteModel : public QAbstractListModel)
* **Что нужно изучить:**
  * Архитектуру **Model/View** в Qt.
  * Переопределение методов `QAbstractListModel`: `rowCount()`, `data()`, `roleNames()`.
  * Методы оповещения View: `beginInsertRows()`, `endInsertRows()`, `beginRemoveRows()`, `endRemoveRows()`, `dataChanged()`.
  * Экспорт методов C++ в QML через макрос `Q_INVOKABLE`.
* **Что делает Пользователь:**
  * Наследует `NoteModel` от `QAbstractListModel`.
  * Внедряет `INoteRepository` через конструктор `NoteModel`.
  * Определяет роли для QML (например: `TitleRole`, `ContentRole`, `DateRole`, `IdRole`).
  * Реализует `Q_INVOKABLE` методы: `addNote(title, content)`, `updateNote(id, title, content)`, `deleteNote(id)`.
  * Регистрирует `NoteModel` и передает ее в QML контекст в `main.cpp`.
* **Что делает AI:**
  * Объясняет, как правильно дергать сигналы сброса и изменения строк модели, чтобы QML интерфейс обновлялся автоматически без лагов.
* **Что получается в итоге:** Полноценная C++ модель, которая передает заметки из БД в QML и позволяет QML вызывать методы CRUD.

---

### Этап 5: Разработка QML Интерфейса (UI/UX)
* **Что нужно изучить:**
  * Как `ListView` в QML автоматически строит список по C++ роли `model.title`, `model.content`.
  * Модульность в QML, `Component`, `Dialog`, `Controls.2`.
* **Что делает AI:**
  * Создает файл стилей `qml/themes/Theme.qml` (цветовая палитра, радиусы, шрифты).
  * Создает `qml/components/NoteCardDelegate.qml` (красивая карточка заметки с hover-эффектами, датой и кнопкой удаления).
  * Создает `qml/pages/NoteListPage.qml` (список `ListView` с поисковой строкой и плавающей кнопкой добавления FAB).
  * Создает `qml/pages/NoteEditorDialog.qml` (диалоговое окно создания/редактирования заметки с полями ввода заглавия и текста).
* **Что делает Пользователь:**
  * Подключает созданные QML компоненты к `NoteModel` в `Main.qml`.
* **Что получается в итоге:** Современный, плавнонимированный интерфейс, отображающий реальные данные из SQLite.

---

### Этап 6: Сквозная интеграция, полировка и UX
* **Что нужно изучить:**
  * Фильтрацию и поиск по списку в QML/C++.
  * Анимацию появления и удаления элементов в QML.
* **Что делает Пользователь:**
  * Проводит интеграционное тестирование всех пользовательских сценариев (создал -> перезапустил приложение -> заметка сохранилась -> отредактировал -> удалил).
* **Что делает AI:**
  * Добавляет анимации для элементов списка заметок (`add`, `remove`, `displaced` в `ListView`).
  * Реализует подтверждение удаления (Confirmation Popup) и состояние пустого списка (Empty State).
* **Что получается в итоге:** Готовый, отполированный **Notes App** проект уровень 2.
