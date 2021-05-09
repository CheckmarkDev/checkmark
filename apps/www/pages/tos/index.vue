<template>
  <div class="tos linear-header">
    <div class="container mx-auto">
      <h1 class="text-4xl py-12">
        Conditions Générales d'Utilisation
      </h1>

      <div class="flex flex-col md:flex-row">
        <nav class="md:w-3/12 mr-8 mb-8 md:mb-0">
          <div class="text-xl mb-4">
            Table des matières
          </div>
          <ul>
            <li
              v-for="(content, anchor) in anchors"
              :key="anchor"
              class="mb-2"
            >
              <a
                :href="`#${anchor}`"
                class="flex bg-gray-100 hover:bg-gray-300 leading-snug rounded py-2 px-4 text-gray-700 hover:text-gray-900"
                v-text="content"
              />
            </li>
          </ul>
        </nav>

        <div class="md:w-7/12 leading-snug">
          <p class="mb-4">
            Bienvenue sur Checkmark.dev !
          </p>

          <p class="mb-4">
            Ces termes et conditions décrivent les règles et règlements pour l'utilisation du site web Checkmark.dev, situé à checkmark.dev. En accédant à ce site Web, nous supposons que vous acceptez ces conditions d'utilisation. Ne continuez pas à utiliser Checkmark.dev si vous n'acceptez pas toutes les conditions énoncés sur cette page.
          </p>

          <address class="mb-8">
            Checkmark.dev appartient à <strong class="font-medium">DA SILVA AVELAR WILLIAM</strong>, une micro-entreprise SIRET numéro <strong class="font-medium">83146136300028</strong> au <strong class="font-medium">10 Rue de Penthièvre, 75008 Paris, FRANCE</strong>
          </address>

          <section>
            <h2
              id="cookies"
              class="text-2xl mb-4 font-medium"
            >
              Cookies
            </h2>

            <p class="mb-4">
              Nous utilisons des cookies. En accédant à Checkmark.dev, vous avez accepté d'utiliser des cookies en accord avec la politique de confidentialité de Checkmark.dev.
            </p>

            <p class="mb-4">
              La plupart des sites Web interactifs utilisent des cookies pour nous permettre de récupérer les détails de l'utilisateur à chaque visite. Les cookies sont utilisés par notre site Web pour activer la fonctionnalité de certaines zones afin de faciliter la visite des personnes visitant notre site Web. Certains de nos affiliés / partenaires publicitaires peuvent également utiliser des cookies.
            </p>
          </section>

          <section>
            <h2
              id="license"
              class="text-2xl mb-4 font-medium"
            >
              License
            </h2>

            <p class="mb-4">
              Sauf indication contraire, Checkmark.dev détient le droit de propriété intellectuelle pour tout le matériel associé à Checkmark.dev.
            </p>

            <p class="mb-4">
              Tout contenu généré par l'utilisateur que ce soit une capture d'écran, des icônes de sites Web et d'autres contenus pouvant être utilisés dans les tâches quotidiennes appartient à leurs propriétaires respectifs.
            </p>

            <p class="mb-4">
              Il ne faut pas:
            </p>

            <ul class="mb-4 list-disc ml-4">
              <li class="mb-4">
                Reproduire, dupliquer ou copier du matériel de Checkmark.dev associé directement à Checkmark.dev
              </li>
              <li class="mb-4">
                Redistribuer le contenu de Checkmark.dev
              </li>
            </ul>

            <p class="mb-4">
              Checkmark.dev se réserve le droit de surveiller tout le contenu généré et de supprimer tout contenu pouvant être considéré comme inapproprié, offensant ou qui entraîne une violation des présentes conditions d'utilisation.
            </p>

            <p class="mb-4">
              Vous garantissez et déclarez que :
            </p>

            <ul class="mb-4 list-disc ml-4">
              <li class="mb-4">
                Vous avez droit aux images que vous publiez sur notre site web et disposez de toutes les licences et consentements nécessaires pour le faire;
              </li>
              <li class="mb-4">
                Les images n'envahissent aucun droit de propriété intellectuelle, y compris, sans limitation, les droits d'auteur, brevets ou marques de commerce d'un tiers;
              </li>
              <li class="mb-4">
                Les images ne contiennent aucun matériel diffamatoire, calomnieux, offensant, indécent ou autrement illégal qui constitue une atteinte à la vie privée;
              </li>
              <li class="mb-4">
                Les images ne seront pas utilisées pour solliciter ou promouvoir des activités illégales.
              </li>
            </ul>

            <p class="mb-4">
              Vous accordez par la présente à Checkmark.dev une licence non exclusive pour utiliser, reproduire, éditer et autoriser d'autres personnes à utiliser, reproduire et éditer vos tâches et projets sous toutes formes, formats ou supports.
            </p>
          </section>

          <section>
            <h2
              id="hyperlinking"
              class="text-2xl mb-4 font-medium"
            >
              Hyperliens vers notre contenu
            </h2>

            <p class="mb-4">
              Les organisations peuvent créer un lien vers notre site Web sans approbation écrite préalable. Ces organisations peuvent créer un lien vers notre page d'accueil, tâches spécifiques, projets spécifiques, des publications ou d'autres informations sur le site Web à condition que le lien: (a) ne soit en aucun cas trompeur; (b) n'implique pas à tort un parrainage, une approbation de la partie liante et de ses produits et / ou services; et (c) s'inscrit dans le contexte du site de la partie liante.
            </p>
          </section>

          <section>
            <h2
              id="iframes"
              class="text-2xl mb-4 font-medium"
            >
              iFrames
            </h2>

            <p class="mb-4">
              Sans approbation préalable et autorisation écrite, vous ne pouvez pas créer de cadres autour de nos pages Web qui modifient de quelque manière que ce soit la présentation visuelle ou l'apparence de notre site Web.
            </p>
          </section>

          <section>
            <h2
              id="personal-infos"
              class="text-2xl mb-4 font-medium"
            >
              Divulgation d'informations personnelles à des tiers
            </h2>

            <p class="mb-4">
              Nous pouvons divulguer des informations personnelles à:
            </p>

            <ul class="mb-4 list-disc ml-4">
              <li class="mb-4">
                des fournisseurs de services tiers dans le but de leur permettre de fournir leurs services, y compris (sans s'y limiter) les fournisseurs de services informatiques, les fournisseurs de stockage de données, d'hébergement et de serveurs, les analyses et les "bug tracker";
              </li>
              <li class="mb-4">
                des tiers pour collecter et traiter les données.
              </li>
            </ul>

            <p class="mb-4">
              Certaines de vos données personnelles sont partagées avec des prestataires de services tiers tels que :
            </p>

            <ul class="mb-4 list-disc ml-4">
              <li class="mb-4">
                <strong class="font-medium">Google</strong>
                <p>
                  Nous passons par Google avec Google Analytics pour collecter des données de visites et d'utilisation sur notre site web.
                </p>
              </li>
              <li class="mb-4">
                <strong class="font-medium">Hotjar</strong>
                <p>
                  Nous utilisons Hotjar pour comprendre le comportement de nos utilisateurs sur notre plateforme. Cela nous permet d'améliorer l'expérience globale des utilisateurs.
                </p>
              </li>
              <li class="mb-4">
                <strong class="font-medium">ScaleWay</strong>
                <p>
                  Nous utilisons ScaleWay pour héberger la plupart de nos serveurs et bases de données. Les informations stockées sont nécessaires pour utiliser notre service.
                </p>
              </li>
              <li class="mb-4">
                <strong class="font-medium">Sentry</strong>
                <p>
                  Sentry est utilisé pour suivre les bugs potentiels dans notre système. Même si vos informations ne sont pas directement utilisées par eux, votre nom et votre adresse e-mail peuvent apparaître dans leur système à des fins de débogage.
                </p>
              </li>
              <li class="mb-4">
                <strong class="font-medium">Mailgun</strong>
                <p>
                  Nous utilisons Mailgun pour envoyer tous nos e-mails transactionnels. Cela signifie que des informations telles que votre nom et votre adresse e-mail peuvent être traitées par Mailgun.
                </p>
              </li>
            </ul>
          </section>

          <section>
            <h2
              id="errors"
              class="text-2xl mb-4 font-medium"
            >
              Erreurs, inexactitudes et omissions
            </h2>

            <p class="mb-4">
              Parfois, il peut y avoir des informations sur notre site ou dans le service qui contiennent des erreurs typographiques, des inexactitudes ou des omissions.
            </p>

            <p class="mb-4">
              Nous nous réservons le droit de corriger toute erreur, inexactitude ou omission, et de modifier ou mettre à jour des informations si des informations dans le service ou sur tout site Web associé sont inexactes à tout moment sans préavis.
            </p>

            <p class="mb-4">
              Nous n'assumons aucune obligation de mettre à jour, de modifier ou de clarifier les informations dans le service ou sur tout site Web associé, y compris, sans s'y limiter sauf si la loi l'exige.
            </p>
          </section>

          <section>
            <h2
              id="optional-tools"
              class="text-2xl mb-4 font-medium"
            >
              Outils et services optionnels
            </h2>

            <p class="mb-4">
              Nous pouvons vous fournir un accès à des outils et services tiers sur lesquels nous ne surveillons ni n'avons aucun contrôle ni aucune contribution.
            </p>

            <p class="mb-4">
              Vous reconnaissez et acceptez que nous fournissons l'accès à ces outils <strong class = "font-medium"> "tels quels" </strong> et <strong class = "font-medium"> "tels que disponibles" </strong> sans aucun garanties, représentations ou conditions de quelque nature que ce soit et sans aucune approbation. Nous déclinons toute responsabilité découlant de ou liée à votre utilisation d'outils tiers optionnels.
            </p>

            <p class="mb-4">
              Toute utilisation par vous des outils optionnels proposés sur le site est entièrement à vos risques et périls et vous devez vous assurer que vous connaissez et approuvez les conditions dans lesquelles les outils sont fournis par les fournisseurs tiers concernés.
            </p>
          </section>

          <section>
            <h2
              id="modifications"
              class="text-2xl mb-4 font-medium"
            >
              Modifications
            </h2>

            <p class="mb-4">
              Checkmark.dev peut réviser ces conditions d'utilisation à tout moment sans préavis. En utilisant ce service et son site Web, vous acceptez d'être lié par la version alors en vigueur des présentes conditions d'utilisation.
            </p>
          </section>

          <section>
            <h2
              id="contact"
              class="text-2xl mb-4 font-medium"
            >
              Informations de contact
            </h2>

            <p class="mb-4">
              Toute question concernant nos conditions d'utilisation doit nous être adressée à contact@checkmark.dev.
            </p>
          </section>

          <div class="my-8 text-gray-700 italic">
            Dernière mise à jour le <time>9 mai 2021</time>.
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import { defineComponent } from "@nuxtjs/composition-api"

  export default defineComponent({
    data () {
      return {
        anchors: {
          cookies: 'Cookies',
          license: 'License',
          hyperlinking: 'Hyperliens vers notre contenu',
          iframes: 'iFrames',
          'personal-infos': 'Divulgation d\'informations personnelles à des tiers',
          errors: 'Erreurs, inexactitudes et omissions',
          'optional-tools': 'Outils et services optionnels',
          modifications: 'Modifications',
          contact: 'Informations de contact'
        }
      }
    },
    head () {
      const title = 'Conditions Générales d\'Utilisation'
      const description = 'Conditions Générales d\'Utilisation de la plateforme Checkmark.dev et de ses services.'

      return {
        title,
        meta: [
          { hid: 'description', name: 'description', content: description },
          { hid: 'og:description', property: 'og:description', content: description },
          { hid: 'og:title', property: 'og:title', content: title }
        ]
      }
    }
  })
</script>
