package todo

import (
	"errors"
	"sync"
)

type Todo struct {
	doing  []bool
	cursor int64
	lock   sync.Mutex
	size   int64
	wal    *Wal
}

func New(size int64) *Todo {
	return &Todo{
		doing:  make([]bool, size),
		cursor: 0,
		size:   size,
	}
}

func (t *Todo) Reset(poz int64) error {
	if poz >= t.size {
		return errors.New("out of bound")
	}
	t.lock.Lock()
	defer t.lock.Unlock()
	if t.wal != nil {
		err := t.wal.Undo(poz)
		if err != nil {
			return err
		}
	}
	t.doing[poz] = false
	t.cursor = 0 // YOLO, Next will do the math
	return nil
}

func (t *Todo) Next() int64 {
	t.lock.Lock()
	defer t.lock.Unlock()
	if t.cursor > t.size {
		return -1
	}
	for i := t.cursor; i < t.size; i++ {
		if !t.doing[i] {
			t.doing[i] = true
			t.cursor = i + 1
			return i
		}
	}
	return -1
}

func (t *Todo) Done(poz int64) error {
	if t.wal != nil {
		return t.wal.Done(poz)
	}
	return nil
}

func (t *Todo) Doing() []bool {
	return t.doing
}
