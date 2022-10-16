package db

import (
	"fmt"
	"go.uber.org/zap"
	"gorm.io/driver/postgres"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

type Config struct {
	DSN    string
	DbType string
	Logger *zap.SugaredLogger
}

type DB struct {
	d   *gorm.DB
	l   *zap.SugaredLogger
	cfg Config
}

func New(cfg Config) (*DB, error) {
	var dbConn *gorm.DB
	var err error
	switch cfg.DbType {
	case "sqlite":
		dbConn, err = gorm.Open(sqlite.Open(cfg.DSN))
	case "pgsql":
		dbConn, err = gorm.Open(postgres.Open(cfg.DSN))
	default:
		return nil, fmt.Errorf("db type [%s] not supported", err)
	}
	if err != nil {
		return &DB{}, err
	}
	var dbObj DB
	if cfg.Logger != nil {
		dbObj.l = cfg.Logger
	} else {
		dbObj.l = zap.S()
	}
	dbObj.d = dbConn
	dbObj.cfg = cfg
	migrations := append(make([]interface{}, 0),
		// types to migrate,
		Record{},
	)

	for _, table := range migrations {
		//err = dbObj.d.Set("gorm:table_options", tableOptions).AutoMigrate(Record{})
		err = dbObj.d.AutoMigrate(table)
		if err != nil {
			return nil, fmt.Errorf("error migrating %T: %s", table, err)
		}
	}

	if err != nil {
		return nil, err
	}
	return &dbObj, err
}
