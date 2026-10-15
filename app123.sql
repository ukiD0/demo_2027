BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "Customers" (
	"id"	VARCHAR NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"name"	VARCHAR NOT NULL,
	"inn"	VARCHAR,
	"adress"	VARCHAR,
	"phone"	VARCHAR,
	"type"	VARCHAR,
	PRIMARY KEY("id"),
	UNIQUE("user_id"),
	FOREIGN KEY("user_id") REFERENCES "Users"("id") ON DELETE CASCADE,
	CONSTRAINT "ck_customer_type" CHECK("type" IN ('Покупатель', 'Поставщик'))
);
CREATE TABLE IF NOT EXISTS "Materials" (
	"id"	INTEGER NOT NULL,
	"name"	VARCHAR NOT NULL,
	"type"	VARCHAR,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "Order_items" (
	"id"	INTEGER NOT NULL,
	"order_id"	INTEGER NOT NULL,
	"product_id"	INTEGER NOT NULL,
	"quantity"	INTEGER NOT NULL,
	"src_id"	INTEGER,
	PRIMARY KEY("id"),
	FOREIGN KEY("order_id") REFERENCES "Orders"("id") ON DELETE CASCADE,
	FOREIGN KEY("product_id") REFERENCES "Products"("id") ON DELETE RESTRICT,
	CONSTRAINT "ck_order_item_qty" CHECK("quantity" > 0)
);
CREATE TABLE IF NOT EXISTS "Orders" (
	"id"	INTEGER NOT NULL,
	"customer_id"	VARCHAR NOT NULL,
	"order_date"	VARCHAR NOT NULL,
	"status"	VARCHAR NOT NULL,
	PRIMARY KEY("id"),
	FOREIGN KEY("customer_id") REFERENCES "Customers"("id") ON DELETE CASCADE,
	CONSTRAINT "ck_order_status" CHECK(length("status") = 4)
);
CREATE TABLE IF NOT EXISTS "Prices" (
	"id"	INTEGER NOT NULL,
	"item_id"	INTEGER,
	"item_type"	INTEGER,
	"price"	FLOAT NOT NULL,
	PRIMARY KEY("id"),
	FOREIGN KEY("item_id") REFERENCES "Products"("id"),
	FOREIGN KEY("item_type") REFERENCES "Materials"("id"),
	CONSTRAINT "ck_price_xor" CHECK(('product_id' IS NOT NULL) <> ('material_id' IS NOT NULL)),
	CONSTRAINT "ck_price_value" CHECK("price" >= 0)
);
CREATE TABLE IF NOT EXISTS "Products" (
	"id"	INTEGER NOT NULL,
	"name"	VARCHAR NOT NULL,
	"category"	VARCHAR NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "Sales" (
	"id"	INTEGER NOT NULL,
	"product_id"	INTEGER,
	"material_id"	INTEGER,
	"discount_percent"	FLOAT NOT NULL,
	PRIMARY KEY("id"),
	FOREIGN KEY("material_id") REFERENCES "Materials"("id") ON DELETE CASCADE,
	FOREIGN KEY("product_id") REFERENCES "Products"("id") ON DELETE CASCADE,
	CONSTRAINT "ck_sale_xor" CHECK(("product_id" IS NOT NULL) <> ("material_id" IS NOT NULL)),
	CONSTRAINT "ck_sale_discount" CHECK("discount_percent" >= 0 AND "discount_percent" <= 100)
);
CREATE TABLE IF NOT EXISTS "Specification" (
	"id"	INTEGER NOT NULL,
	"product_id"	INTEGER NOT NULL,
	"material_id"	INTEGER NOT NULL,
	"qty"	FLOAT NOT NULL,
	PRIMARY KEY("id"),
	CONSTRAINT "uq_spec_product_material" UNIQUE("product_id","material_id"),
	FOREIGN KEY("material_id") REFERENCES "Materials"("id") ON DELETE RESTRICT,
	FOREIGN KEY("product_id") REFERENCES "Products"("id") ON DELETE CASCADE,
	CONSTRAINT "ck_spec_qty" CHECK("qty" > 0)
);
CREATE TABLE IF NOT EXISTS "Users" (
	"id"	INTEGER NOT NULL,
	"login"	VARCHAR NOT NULL,
	"password"	VARCHAR NOT NULL,
	"full_name"	VARCHAR NOT NULL,
	"role"	VARCHAR NOT NULL,
	"is_locked"	INTEGER NOT NULL,
	"attempts"	INTEGER NOT NULL,
	"locked_at"	VARCHAR,
	"last_login_at"	VARCHAR,
	"is_active"	INTEGER NOT NULL,
	"created_at"	VARCHAR,
	PRIMARY KEY("id"),
	UNIQUE("login")
);
INSERT INTO "Users" VALUES (1,'admin','admin','Администратор Системы','Администратор',0,0,NULL,NULL,1,'2026-10-05T20:45:32');
INSERT INTO "Users" VALUES (2,'ivanov','1234','Иванов Иван','Пользователь',0,0,NULL,NULL,1,'2026-10-05T20:45:32');
INSERT INTO "Users" VALUES (3,'petrov','qwerty','Петров Пётр','Пользователь',0,0,NULL,NULL,1,'2026-10-05T20:45:32');
INSERT INTO "Users" VALUES (4,'123','123','123','Пользователь',0,0,NULL,NULL,1,NULL);
INSERT INTO "Users" VALUES (5,'1234','12344','12344','Пользователь',0,0,NULL,NULL,1,NULL);
COMMIT;
