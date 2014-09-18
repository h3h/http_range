# Range HTTP Header Spec for HTTP APIs

Largely from [Heroku's Range header documentation][1].

 [1]: https://devcenter.heroku.com/articles/platform-api-reference#ranges

```
Range: <attr> [<]>]<first>..<last>[<[>][; order=<asc|desc>][; max=<int>]
```

The `[` and `]` exclusion operators are [described thusly][2], assuming a range
from `a` to `z`:

 [2]: https://github.com/interagent/http-api-design/issues/36#issuecomment-48226357

 * `a..z` to get everything
 * `a..` to get the default size worth of results greater than or equal to a
 * `..z` to get the default size worth of results less than or equal to z
 * `]a..` results greater than a (not greater than or equal as above)
 * `..z[` results less than z (not less than or equal as above)

Intentional deviations from Heroku's design:

 * Separate `order` and `max` into separate parameters delimited by `;` to avoid
   two needless rounds of parsing (`;` and `,`)
