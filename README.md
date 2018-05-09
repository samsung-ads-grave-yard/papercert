![cert-n-coffee](.eyecandy/cert-n-coffee.jpg)

# papercert

Script that dumps a key and certificate to a PDF for printing. Also provdes a
script for dumping CSRs to paper.

## Installation

```shell
git clone ${THIS_REPO}

# For CentOS/RHEL/Fedora
sudo yum install -y dmtx-utils ImageMagick

# For Ubuntu(s)
sudo apt install dmtx-utils imagemagick
```

## Usage

```shell
./papercert.sh key.pem cert.pem
xdg-open combined.pdf
```

```shell
./papercsr.sh domain.com.csr
xdg-open <CN>-combined.pdf
# Don't forget to print two-sided and save 50% the trees!
```

## Restoring the certificates

This was tested with a [Motorola/Symbol
DS4208](https://www.zebra.com/gb/en/products/scanners/general-purpose-scanners/handheld/ds4208.html)
scanner.

Disabling the the suffix setting that outputs CR,LF is pretty handy. Also when
scanning, try to aim for the lower left corner of the codes, and the targeting
dot should be roughly a of one of the squares.

```plaintext
|----|----|
|    |    |
|    |    |
|----|----|
|    |    |
|O   |    |  <- Try and aim about here
|----|----|
```

Some modern text editors seem unhappy about cursor position. For example Visual
Studio code improperly line feeds, even with line feed disabled on the scanner.

Vim seems to work just fine.

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D
