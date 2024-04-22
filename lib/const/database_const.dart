const String dbName = "task.db";

const String idColumn = 'id';
const String nameColumn = 'name';
const String descriptionColumn = 'description';
const String deadlineColumn = 'deadline';
const String doneDateColumn = 'doneDate';
const String priorityColumn = 'priority';
const String ownerColumn = 'owner';
const String statusColumn = 'status';
const String taskTableName = 'tasks';

const String createTable = ''' CREATE TABLE IF NOT EXISTS $taskTableName (
	$idColumn	INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	$nameColumn	TEXT NOT NULL,
	$descriptionColumn	TEXT,
	$deadlineColumn	int,
	$doneDateColumn	int,
  $priorityColumn	int,
  $ownerColumn	TEXT,
  $statusColumn	TEXT
)
''';
