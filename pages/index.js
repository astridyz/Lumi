import React, { useState } from 'react';
import Link from "@docusaurus/Link";
import clsx from 'clsx';
import Layout from '@theme/Layout';
import styles from './index.module.css';

function HomepageHeader() {
    const [showFlag, setShowFlag] = useState(false);

    const handleLogoClick = () => {
        setShowFlag(!showFlag);
    };

    return (
        <header className={clsx('hero hero--primary', styles.heroBanner)}>
            {showFlag && <div className={styles.transFlag}></div>}
            <div className="container">
                <div className={styles.headerContent}>
                    <img
                        src="compactedLogo.svg"
                        alt="Lumi Logo"
                        className={styles.logo}
                        onClick={handleLogoClick}
                    />
                    <div className={styles.textContent}>
                        <p className={styles.heroTitle}>
                            A Discord API Wrapper
                        </p>
                        <p className={styles.heroSubtitle}>
                            Connect to Discord quickly and easily with our powerful library
                        </p>
                        <Link
                            className="button button--primary button--lg"
                            to="/docs/intro"
                        >
                            Get Started
                        </Link>
                    </div>
                </div>
            </div>
            <img className={styles.homeWaves} src="wave.svg" alt="A wave" />
        </header>
    );
}

function Feature({ title, description }) {
    return (
        <div className="col col--4">
            <div className={styles.feature}>
                <h2>{title}</h2>
                <p>{description}</p>
            </div>
        </div>
    );
}

function Features() {
    const features = [
        {
            title: 'Versatile Expansion',
            description: 'Lumi is built to accommodate your evolving needs, allowing seamless integration of additional components.'
        },
        {
            title: 'User-Friendly Interface',
            description: 'Designed with beginners in mind, Lumi provides an intuitive interface for a smooth programming experience.'
        },
        {
            title: 'Accessible Learning Resources',
            description: 'Unlock the full potential of Lumi with an extensive collection of examples and comprehensive documentation.'
        }
    ];

    return (
        <section className={styles.features}>
            <div className="container">
                <div className="row">
                    {features.map((feature, idx) => (
                        <Feature
                            key={idx}
                            title={feature.title}
                            description={feature.description}
                        />
                    ))}
                </div>
            </div>
        </section>
    );
}

export default function Home() {
    return (
        <Layout description="A Discord API Wrapper written in Luau">
            <HomepageHeader />
            <main>
                <Features />
            </main>
        </Layout>
    );
}
