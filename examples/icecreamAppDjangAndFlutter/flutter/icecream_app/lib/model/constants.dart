// database name and field constants
const dbFile = 'icecream_database.db';

// flavor table (local and REST API)
const dbFlavorTableName = 'flavors';
const dbFlavorId = 'id';
const dbflavorName = 'name';

// order table (from REST API)
const dbOrderId = 'id';
const dbCustName = 'customer_name';
const dbIsCompleted = 'is_completed';
const dbScoopsList = 'scoops';

const localFile = "cached.txt";

// GUI display text
const ordersDisplayTitle = 'Ice Cream Orders';
const flavorsDisplayTitle = 'List of Flavors';
const flavorDisplayTitle = 'Update Flavor';
const renameFlavor = 'Rename the flavor';
const renamedTo = 'Renamed to';
const submitUpdate = 'Submit';
const flavorSeparator = ', ';

const databaseLabel = "(sqflite)";
const localFileLabel = "(local file)";

// Error messages
const missingTextError = 'Please enter some text';
const noMatch = 'Unavailable';

// REST API strings
const authorizationKey = 'Authorization';
const apiKey = 'Api-Key ITpc7avb.88WpMCB6XVq6inWHeGOwiMAngLL2TS9o';
const restPath = '/rest/orders';
const urlPrefix = 'http://10.48.4.141:8000';
//const urlPrefix = 'http://192.168.1.130:8000';
