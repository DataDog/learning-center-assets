from collections import namedtuple

Thought = namedtuple('Thought', [
    'quote', 'author',
])


thoughts = {
    'religion': Thought(
        quote='My religion consists of a humble admiration of the illimitable superior spirit who reveals himself in the slight details we are able to perceive with our frail and feeble mind.',
        author='Albert Einstein',
    ),
    'technology': Thought(
        quote='For a successful technology, reality must take precedence over public relations, for Nature cannot be fooled.',
        author='Richard Feynman',
    ),
    'war': Thought(
        quote='One is left with the horrible feeling now that war settles nothing; that to win a war is as disastrous as to lose one.',
        author='Agatha Christie',
    ),
    'work': Thought(
        quote='Life grants nothing to us mortals without hard work.',
        author='Horace',
    ),
    'music': Thought(
        quote='Ah, music. A magic beyond all we do here!',
        author='J. K. Rowling',
    ),
    'humankind': Thought(
        quote='I think that God in creating Man somewhat overestimated his ability.',
        author='Oscar Wilde',
    ),
}