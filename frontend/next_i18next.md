# next-i18next

## Setup

- [files changed](https://github.com/tsengyushiang/next.js/pull/2/files)

- install package

    ```
    yarn add next-i18next
    ```

- setup `next-i18next.config.js`

    ```javascript
    module.exports = {
        i18n: {
            defaultLocale: 'en',
            locales: ['en', 'zh', 'zh-tw'], // folders in ./public/locales
        },
        interpolation: {
            escapeValue: false,
        },
        lowerCaseLng: true, //support zh-tw
    };
    ```

- setup `next.config.js`
    ```javascript
    const { i18n } = require('./next-i18next.config');

    const nextConfig = {
            i18n,
            reactStrictMode: true,
        }

    module.exports = nextConfig;
    ```

- add language files

    ```
    .
    └── public
        └── locales
            ├── en
            |   └── common.json
            └── zh
            |   └── common.json
            └── zh-tw
                └── common.json
    ```
    `common.json`
    ```json
    {
        "title":"i18n 中文(zh-tw)"
    }
    ```
    

- load languages from server side on your page

    ```javascript
    import { serverSideTranslations } from 'next-i18next/serverSideTranslations';

    export async function getStaticProps({ locale }) {
        return {
            props: {
            ...(await serverSideTranslations(locale, ['common'])),  
            // namespace "common" from common.json in ./public/locales/{language}/{namespace}.json format
            // Will be passed to the page component as props
            },
        };
    }
    ```

- apply translation to `pages/_app.js`

    ```javascript
    import { appWithTranslation } from 'next-i18next';

    function MyApp({ Component, pageProps }) {
        return <Component {...pageProps} />;
    }

    export default appWithTranslation(MyApp);
    ```

## Testing
    
- add page `demo-next-i18next.js` and visit http://localhost:3000/demo-next-i18next
    
    ```javascript
    import { serverSideTranslations } from 'next-i18next/serverSideTranslations';

    import { useRef, useEffect, useState } from 'react'
    import { useTranslation } from 'next-i18next'
    import { useRouter } from 'next/router';

    export default function LanguageSwitch() {
        const select = useRef(null);
        const router = useRouter();
        const { t } = useTranslation('common');

        useEffect(() => {
            const activeLanguage = router?.locales?.find((el) => el === router.locale);
            select.current.value = activeLanguage;
        }, []);

        const handleChange = () => {
            // window.location.href = `/${select.current.value}${router.asPath}`;
            const tag = select.current.value;
            const { asPath } = router;
            router.push(asPath, asPath, { locale: tag });
        };

        return (
            <>
                <p>{t('title')}</p>

                <select onChange={handleChange} ref={select}>
                    {router?.locales?.map((language, index) => (
                        <option key={index} value={language}>
                            {language}
                        </option>
                    ))}
                </select>
            </>
        );
    };

    export async function getStaticProps({ locale }) {
        return {
            props: {
                ...(await serverSideTranslations(locale, ['common'])),
                // namespace "common" from common.json in ./public/locales/{language}/{namespace}.json format
                // Will be passed to the page component as props
            },
        };
    }
    ```
