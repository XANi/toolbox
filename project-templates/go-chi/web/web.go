package web

type Web struct {
	cfg      *Config
	renderer *Renderer
}
type Config struct {
}

func New(c *Config) (*Web, error) {
	r, err := NewRenderer(c)
	w := Web{
		cfg:      c,
		renderer: r,
	}

	return &w, err
}
