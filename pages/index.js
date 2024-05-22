import React, { useState } from 'react';
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
                            A Discord API wrapper
                        </p>
                        <p className={styles.heroSubtitle}>
                            Connect to Discord quickly and easily with our powerful library
                        </p>
                        <div className={styles.buttons}>
                            <a className="button button--primary button--lg" href="/docs/intro">
                                Get Started
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <img className={styles.homeWaves} src="waves.svg" alt="a soft wavey boundary between two sections of the website" />
        </header>
    );
}

function Feature({ title, description, icon }) {
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
        <Layout description="Lumi: Uma biblioteca para API do Discord">
            <HomepageHeader />
            <main>
                <Features />
            </main>
        </Layout>
    );
}
