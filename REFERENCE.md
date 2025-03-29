# Core Function Reference

## autoload.php

This file only stores the PHP autoloader, there are no classes in this file.

## base32.php


```php
object $base32 = new Base32(string $text);
string $encoded = $base32->value;
```

#### The Base-32 Alphabet (RFC-3548) Table:

Char | Binary | Char | Binary
-|-|-|-
  A  | 00000 |  Q  | 10000
  B  | 00001 |  R  | 10001
  C  | 00010 |  S  | 10010
  D  | 00011 |  T  | 10011
  E  | 00100 |  U  | 10100
  F  | 00101 |  V  | 10101
  G  | 00110 |  W  | 10110
  H  | 00111 |  X  | 10111
  I  | 01000 |  Y  | 11000
  J  | 01001 |  Z  | 11001
  K  | 01010 |  2  | 11010
  L  | 01011 |  3  | 11011
  M  | 01100 |  4  | 11100
  N  | 01101 |  5  | 11101
  O  | 01110 |  6  | 11110
  P  | 01111 |  7  | 11111

When encoding data, we are taking a stream of bits and breaking it down from byte-width *(8 bits)* to a width of 5 bits. Then we are associating the 5 bit wide chunk with the Base-32 alphabet table defined above.

Let's assume our input string is `Test`, let's see the Base-32 encoding step-by-step:

Char | ASCII Encoding (7 bit signed)
-|-
  T  | 01010100
  e  | 01100101
  s  | 01110011
  t  | 01110100


We take the ASCII encoded bytes and split them into 5-bit wide chunks:

```
T|e|s|t ->

01010100|01100101|01110011|01110100 ->

01010|10001|10010|10111|00110|11101|00 + 000
```

Since the number of bits in our ASCII encoded string wasn't evenly divisible by the width of a Base-32 character *(5 bits)*, we had to append enough padding bits until the combined bit count is evenly divisible by 5.

Now we associate the 5-bit wide characters with the Base-32 alphabet table:

Char | Base-32 Encoding (5 bit unsigned)
-|-
  K  | 01010
  R  | 10001
  S  | 10010
  X  | 10111
  G  | 00110
  5  | 11101
  A  | 00000

So what we ended up with thus far is: `Test -> KRSXG5A`, however we must append padding characters to our Base-32 encoded string until the length of the encoded string is evenly divisible by 8.

Our unpadded Base-32 encoded string is 7 characters long which means that we require one padding character to complete the Base-32 encoding steps:

`Test -> KRSXG5A=`

## database.php

```php
object $postgres = new PostgreSQL(string $hostname, int $port = 5432, ?string $username, ?string $password, ?string $dbname);
object $unix_postgres = new PostgreSQLSock(string $sockfile = 'unix:///var/run/pgsql.sock', ?string $username, ?string $password, ?string $dbname);

object $mariadb = new MySQL(string $hostname, int $port = 3306, ?string $username, ?string $password, ?string $dbname);
object $unix_mariadb = new MySQLSock(string $sockfile = 'unix:///var/run/mysqld.sock', ?string $username, ?string $password, ?string $dbname);

object $redis = new Redis(string $hostname, int $port = 6379, ?string $username, ?string $password, ?string $dbname);
object $unix_redis = new RedisSock(string $sockfile = 'unix:///var/run/redis.sock', ?string $username, ?string $password, ?string $dbname);

object $sqlite = new SQLite(?string $filename); // null filename is in-memory.
PDO|Redis|null $connection = $database->value;

public Database::run(?PDO|?Redis $conn, string $query, ?array $params);
```

## template.php

```php
object $template = new Template(string $template_data, array $template_vars);
string|null $template->value;
```

## totp.php

```php
object $totp = new TOTP(string $key, int $start = 0, int $token_length = 6, int $duration = 30);
object $hotp = new HOTP(int $counter, int $token_length = 6, string $key);

string|null $hotp->value;
string|null $totp->value;
```
