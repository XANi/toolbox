package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

var testStrings []string

func TestExample(t *testing.T) {
	a := assert.New(t)
	a.Equal(1, 1, "test")
}
