package db

import (
	"github.com/stretchr/testify/require"
	"go.uber.org/zap/zaptest"
	"gorm.io/gorm/logger"
	"os"
	"sync"
	"testing"
)

type tLogger struct {
	t *testing.T
}

func (t *tLogger) Printf(s string, args ...interface{}) {
	t.t.Logf(s, args...)
}

var testDB *DB
var tdbLock sync.Mutex

func DBTestInit(t *testing.T) *DB {
	tdbLock.Lock()
	defer tdbLock.Unlock()
	if testDB != nil {
		return testDB
	}
	dsn := os.Getenv("TEST_DB_PATH")
	if len(dsn) < 1 {
		dsn = t.TempDir() + "/t.sqlite"
	}
	dsn = dsn + "?_journal_mode=WAL"
	db, err := New(Config{
		DSN:    dsn,
		DbType: "sqlite",
		Logger: zaptest.NewLogger(t).Sugar(),
	})

	if err != nil {
		t.Logf("err initializing DB: %s", err)
	}
	tl := &tLogger{t: t}
	gormLogger := logger.New(tl, logger.Config{
		SlowThreshold:             0,
		Colorful:                  false,
		IgnoreRecordNotFoundError: false,
		LogLevel:                  logger.Info,
	})
	db.d.Config.Logger = gormLogger
	require.Nil(t, err)
	testDB = db
	return db
}
