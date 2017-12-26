package main

import (
	"fmt"
	"math/rand"
	"time"

	"github.com/gonum/matrix/mat64"
)

func gen(sz int) []float64 {
	ad := make([]float64, sz*sz)
	for i := range ad {
		ad[i] = float64(rand.Intn(1000)) / float64(rand.Intn(1000)+2)
	}
	return ad
}

func main() {
	sz := 500
	ad := gen(sz)
	bd := gen(sz)
	a := mat64.NewDense(sz, sz, ad)
	b := mat64.NewDense(sz, sz, bd)

	var m mat64.Dense
	t0 := time.Now()
	m.Mul(a, b)
	elap := time.Since(t0)
	fmt.Printf("elap=%v\n", elap) // 24 msec
}
